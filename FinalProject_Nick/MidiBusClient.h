//
//  MidiBusClient.h
//  MidiBus
//
//  Created by Nic Grant on 16/05/2013.
//  Copyright (c) 2013 Soft Audio Pty Ltd. All rights reserved.
//

// Objective-C Wrapper for MidiBus C Library
// Please see the full documentation and examples for this
// class in the accompanying documentation
#import <Foundation/Foundation.h>
#include "midibus.h"
#import "OMACApplicationRegistry.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

// simple trace mechanism
// this can be set to YES to log trace via NSLog 
// Don't leave this set to YES in production!
extern BOOL MBCTrace;
#define MBC_TRACE(args...) { if (MBCTrace == YES) NSLog(args); }

// MidiBus client protocol
@protocol MidiBusClientDelegate <NSObject>

// mandatory, method to receive MIDI events on
- (void) receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT*)event;

@optional

// define this if you want to be notified that engine started
- (void) handleMidiBusClientStartNotification:(NSNumber*)status;

// define this if you want to be notified of changes to interfaces
// or network status
- (void) handleMidiBusClientNotification:(uint8_t)type;

// define this if you want sysex notifications
- (void) handleMidiBusClientSysexNotification:(uint8_t)index withStatus:(eMidiBusStatus)status;

// override network support (default == YES)
- (BOOL) includeMidiBusNetworkSupport;

// override virtual port mode (default = eMidiBusVirtualModeDual)
- (eMidiBusVirtualMode) virtualMidiBusMode;

@end

@interface MidiBusClient : NSObject
#if TARGET_OS_IPHONE
<OMACApplicationRegistryDelegate>
#endif
{
    @public
#if TARGET_OS_IPHONE
    OMACApplicationRegistry* omac;
#endif
    
    @protected
    NSArray* omac_apps;
    
    @private
    BOOL network_enabled;
    uint8_t virtual_mode;
}

// initialise and start MidiBus - call once at app startup
+ (MidiBusClient*) startWithApp:(NSString*)name andDelegate:(id)delegate;

// enable an interface. By default only hardware and your own virtual
// ports are enabled
+ (void) enableMidiBusInterface:(uint8_t)index andFlag:(BOOL)flag;

// set channels on which to receive channelised messages. By default
// only channel 1 is listened to
+ (void) setMidiBusChannels:(uint16_t)channelMap;

// obtain index of own virtual interface
+ (uint8_t) getMidiBusOwnInterfaceIndex;

// alloc a new empty small event for sending, remember to dispose when finished
+ (MIDIBUS_MIDI_EVENT*) setupSmallEvent;
+ (void) disposeSmallEvent:(MIDIBUS_MIDI_EVENT*)event;

// send an event on an interface
+ (eMidiBusStatus) sendMidiBusEvent:(uint8_t)index withEvent:(MIDIBUS_MIDI_EVENT*)event;

#if TARGET_OS_IPHONE
// attempt to extract an OMACApplication record for a given
// interface ident - used for binding fast-switch actions
// in your app to launch another app
+ (OMACApplication*) LocateOMACApp:(char*)ident;
#endif

@property(nonatomic, assign) id<MidiBusClientDelegate> mbs_delegate;

@end

// NSObject wrapper object for interface struct
@interface MidiBusInterface : NSObject
{
    @public
    MIDIBUS_INTERFACE* interface;
}

- (id) initWithPointer:(MIDIBUS_INTERFACE*)interface_pointer;
@end

@interface MidiBusInterfaceQuery : NSObject
{
    uint8_t obj_filter;
    uint8_t ports;
    MIDIBUS_INTERFACE* interface_array;
    NSMutableArray* result;
}

- (id) initWithFilter:(uint8_t)filter;
- (NSArray*) getInterfaces;
- (void) dealloc;

@end