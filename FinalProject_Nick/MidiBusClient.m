//
//  MidiBusClient.m
//  MidiBus
//
//  Created by Nic Grant on 16/05/2013.
//  Copyright (c) 2013 Soft Audio Pty Ltd. All rights reserved.
//

#import "MidiBusClient.h"
#import "midibus.h"

// the Client singleton
static MidiBusClient* singleton = 0;

// turn trace to console via NSLog of this class on/off
BOOL MBCTrace = NO;

// set to 1 to send MidiBus Client trace messages to the console
#define LOG_TO_CONSOLE 1

// uncomment to make MidiBus C library generate trace too
//#define MIDIBUS_TRACING 1

// C callbacks from midibus engine
static void new_message(MIDIBUS_MIDI_EVENT* event, void* ref)
{
    MBC_TRACE(@"MBC new message 0x%02X, length: %i", event->data[0], event->length);

#if TARGET_OS_IPHONE
    // handle (and suppress) omac messages
    if (IS_OMAC_MIDI_MESSAGE(event->data))
    {
        [singleton->omac processMIDIMessage:event->data :event->length];
        return;
    }
#endif
    
    MidiBusClient* mbc = (__bridge MidiBusClient*)ref;
    [mbc.mbs_delegate receivedMidiBusClientEvent:event];
}

static void new_notify(uint8_t notify_type, void* ref)
{
    MBC_TRACE(@"MBC new notification");
    MidiBusClient* mbc = (__bridge MidiBusClient*)ref;
    if ([mbc.mbs_delegate
           respondsToSelector: @selector(handleMidiBusClientNotification:)])
        [mbc.mbs_delegate handleMidiBusClientNotification:notify_type];
}

static void sysex_notify(uint8_t index, eMidiBusStatus status, void* ref)
{
    MBC_TRACE(@"MBC sysex notification");
    MidiBusClient* mbc = (__bridge MidiBusClient*)ref;
    if ([mbc.mbs_delegate
         respondsToSelector: @selector(handleMidiBusClientSysexNotification:withStatus:)])
        [mbc.mbs_delegate handleMidiBusClientSysexNotification:index withStatus:status];
}


@implementation MidiBusClient
@synthesize mbs_delegate;

// Start the MidiBus engine
+ (MidiBusClient*) startWithApp:(NSString*)name andDelegate:(id)delegate
{
    // disallow the engine from being started more than once
    if (!singleton)
    {
    
#ifdef MIDIBUS_TRACING
        // set up midibus tracing (do not use this code on a shipped product!!!)
        NSArray *paths =
             NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
             NSUserDomainMask, YES);
        NSString* trace_filename = [NSString stringWithFormat:@"%@/%s.log",
            [paths objectAtIndex:0], "midibus"];
        midibus_trace([trace_filename UTF8String], 1);
        MBCTrace = YES;
#endif
    
        // create and initialise the singleton object
        singleton = [MidiBusClient alloc];
    
        // determine if network is enabled
        singleton->network_enabled = YES;
        if ([delegate respondsToSelector: @selector(includeMidiBusNetworkSupport)])
        {
            singleton->network_enabled = [delegate includeMidiBusNetworkSupport];
            MBC_TRACE(@"startWithApp network enabled/disabled: %i via client delegate", singleton->network_enabled);
        }
        
        // virtual mode
        singleton->virtual_mode = eMidiBusVirtualModeDual;
        if ([delegate respondsToSelector: @selector(virtualMidiBusMode)])
        {
            singleton->virtual_mode = [delegate virtualMidiBusMode];
            MBC_TRACE(@"startWithApp virtual mode: %i via client delegate", singleton->virtual_mode);
        }

        // initialise midibus engine
        eMidiBusStatus status = midibus_initialise([name UTF8String],
           singleton->virtual_mode,
           &new_message, (__bridge void*)singleton,
           &new_notify, (__bridge void*)singleton,
           &sysex_notify, (__bridge void*)singleton,
           MIDIBUS_TRANSPORT_COREMIDI,
           singleton->network_enabled);
 
        if (status == eMidiBusStatusVirtSetupFail)
           NSLog(@"Failed to setup virtual ports. Do you need to define 'audio' background mode in Info.plist?");

#if TARGET_OS_IPHONE
        // start omac (NB - no longer does live updating)
        // OMACTrace = MBCTrace;
        singleton->omac = [OMACApplicationRegistry instanceWithAppName:name];
#endif
        // call delegate with status when Start finished if requested
        MBC_TRACE(@"Start - status: %i", status);
        if ([delegate respondsToSelector: @selector(handleMidiBusClientStartNotification:)])
        {
            NSNumber* ns_status = [NSNumber numberWithInt:status];
            [delegate performSelectorOnMainThread:@selector(handleMidiBusClientStartNotification:) 
                                        withObject:ns_status waitUntilDone:NO];
        }
    }

    // update the delegate
    singleton.mbs_delegate = delegate;
    
    return singleton;
}

+ (void) enableMidiBusInterface:(uint8_t)index andFlag:(BOOL)flag
{
    midibus_enable_interface(index, flag);
}

+ (void) setMidiBusChannels:(uint16_t)channelMap
{
    midibus_set_incoming_channels(channelMap);
}

+ (MIDIBUS_MIDI_EVENT*) setupSmallEvent
{
    MIDIBUS_MIDI_EVENT* event = malloc(sizeof(MIDIBUS_MIDI_EVENT));
    if (event) midibus_setup_small_message(event);
    return event;
}

+ (uint8_t) getMidiBusOwnInterfaceIndex
{
    static MidiBusInterfaceQuery* query = nil;
    if (query == nil)
        query = [[MidiBusInterfaceQuery alloc] initWithFilter:MIDIBUS_INTERFACE_FILTER_ONLY_MYVIRTUAL];
    NSArray* results = [query getInterfaces];
    if (results.count)
    {
        MidiBusInterface* interface_obj = [results objectAtIndex:0];
        MIDIBUS_INTERFACE* interface = interface_obj->interface;
        return interface->index;
    }
    return MIDIBUS_NO_INTERFACES;
}

+ (void) disposeSmallEvent:(MIDIBUS_MIDI_EVENT*)event { if (event) free(event); }

+ (eMidiBusStatus) sendMidiBusEvent:(uint8_t)index withEvent:(MIDIBUS_MIDI_EVENT*)event
{
    return midibus_send(index, event);
}

#if TARGET_OS_IPHONE
+ (OMACApplication*)LocateOMACApp:(char*)ident;
{
    if (singleton && singleton->omac_apps && ident)
    {
        NSString* compare_str = [NSString stringWithUTF8String:ident];
        for (id obj in singleton->omac_apps)
        {
            OMACApplication* app = (OMACApplication*)obj;
            if ([app.virtualPortName compare:compare_str] == NSOrderedSame)
                return app;
        }
    }
    
    // try and punt the url based on the ident and return a fake app
    NSString* url_str = [[NSString stringWithFormat:@"%s://",ident] lowercaseString];
    NSURL* url = [NSURL URLWithString:url_str];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ||
        [[UIApplication sharedApplication] canOpenURL:url] == YES)
    {
        // we guessed the URL!
        MBC_TRACE(@"LocateOMACApp - mapped virtual port %s to url %@", ident, url_str);
        NSString* ident_ns = [NSString stringWithUTF8String:ident];
        NSDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:ident_ns forKey:@"Application"];
        [dic setValue:ident_ns forKey:@"VirtualPortName"];
        [dic setValue:url_str forKey:@"LaunchURL"];
        
        // maintain a cache (in dictionary) of punted apps
        static NSMutableDictionary* cached_punted_apps = nil;
        if (!cached_punted_apps) cached_punted_apps = [NSMutableDictionary dictionaryWithCapacity:16];
        
        // return cached punted app or add a new one to cache
        OMACApplication* punted_app = cached_punted_apps[ident_ns];
        if (!punted_app)
        {
            MBC_TRACE(@"LocateOMACApp - creating cached punted app");
            punted_app = [[OMACApplication alloc] initWithDictionary:dic];
            cached_punted_apps[ident_ns] = punted_app;
        }
        
        return punted_app;
    }
    
    return nil;
}
#endif

#if TARGET_OS_IPHONE
#pragma mark Omac Registry protocol methods
- (void)OMACUpdateComplete:(enum eOMACUpdateStatus)status
{
    MBC_TRACE(@"MidiBusClient OMACUpdateComplete status: %i", status);
    
    omac_apps = [omac filteredVirtualMIDIApps];
}
#endif

@end

@implementation MidiBusInterface
- (id)initWithPointer:(MIDIBUS_INTERFACE*)interface_pointer
{
    interface = interface_pointer; return self;
}
- (void)dealloc { MBC_TRACE(@"MidiBusInterface dealloc"); }
@end

@implementation MidiBusInterfaceQuery

- (id)initWithFilter:(uint8_t)filter
{
    MBC_TRACE(@"MidiBusInterfaceQuery initWithFilter 0X%02X", filter);
    obj_filter = filter;
    ports = 0;
    interface_array = 0;
    result = [[NSMutableArray alloc] initWithCapacity:64];
    return self;
}

- (NSArray*)getInterfaces
{
    MBC_TRACE(@"MidiBusInterfaceQuery getInterfaces");
    if (result.count > 0)
        [result removeAllObjects];

    // call C library with all transports and user filter
    midibus_get_interfaces(&ports, &interface_array, MIDIBUS_TRANSPORT_ALL, obj_filter);
    for (uint8_t i = 0; i < ports; i++)
    {
        MidiBusInterface* interface = [[MidiBusInterface alloc] initWithPointer:&interface_array[i]];
        [result addObject:interface];
    }

    return result;
}

- (void)dealloc
{
    MBC_TRACE(@"MidiBusInterfaceQuery dealloc");

    // clean up from C library, NB result array should be ARC released
    if (interface_array != 0) free(interface_array);
}

@end
