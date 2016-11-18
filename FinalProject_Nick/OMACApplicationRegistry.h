// OMAC - Open Music App Collaboration
// Free and unencumbered software - NO WARRANTY
// OMACApplicationRegistry.h
// Author: Nic Grant - apps@audeonic.com
// Revision: $Revision: 1.5 $, $Date: 2014/02/05 12:39:21 $

// macro for determining if message is an OMAC message
#define IS_OMAC_MIDI_MESSAGE(BYTES) (BYTES[0] == 0xF0 && BYTES[1] == 0x1F)

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

// status returned by update method
enum eOMACUpdateStatus
{
    eOMACNoChange = 0,             // current plist is most current
    eOMACUpdated = 1,              // a new plist was downloaded
    eOMACUpdateStarted = 2,        // update is started in a background thread
    eOMACVersionCheckFailed = 3,   // failed to get current version from DNS
    eOMACFetchFailed = 4           // failed to fetch new version from source
};

// this can be set to YES to log trace via NSLog 
// Don't leave this set to YES in production!
extern BOOL OMACTrace;
#define OMAC_TRACE(args...) { if (OMACTrace == YES) NSLog(args); }

// delegate protocol - implement this if you want to
// do updates in the background thread (you know you want to!)
@protocol OMACApplicationRegistryDelegate <NSObject>
@optional

- (void)OMACUpdateComplete:(enum eOMACUpdateStatus)status;

@end

// Application Registry class
@interface OMACApplicationRegistry : NSObject
{
    UInt32 plist_version;
    NSString* bundle_pname;
    NSString* cache_pname;
    NSDictionary* dic;
    
    NSMutableArray* all_apps;
    NSMutableArray* filtered_apps;
    NSMutableArray* filtered_vm_apps;

    enum eOMACUpdateStatus update_result;
}

// usable methods
// please see example code at the OMAC Registry site, currently:
// http://omac.audeonic.com.guide.shtml

// obtain shared instance of the registry class. The name parameter should
// be the same name as you have registered at the registry. You only need
// to pass in the name the first time you call this function, you can pass
// in nil later
+ (id)instanceWithAppName:(NSString*)name;

// clean up - use in your dealloc
+ (void)shutdown;

// obtain an updated property list file if needed. If your controller
// implements the delegate protocol and you have a delegate set, then
// the update will occur in a background thread and the completion method
// will be called when the update completes. If delegate is not set, then
// the update will occur synchronously and the method will return when the
// update processing is complete
- (enum eOMACUpdateStatus)update;

// call this function to refresh the 'installed' flag of the list of apps
// if you want to pick up newly ijnstalled applications dynamically
- (void)refresh;

// provides an array of OMACApplication objects that have Virtual MIDI
// ports with your own app and unsupported apps for the current device/IOS
// version removed. This array is a subset of the filteredApps array (see below)
- (NSArray*)filteredVirtualMIDIApps;

// provides an array of OMACApplication objects with your own app and
// unsupported apps for the current device/IOS version removed. This
// array is a subset of the allApps array (see below)
- (NSArray*)filteredApps;

// provides the full list of OMACApplication objects in the property
// list sorted by installed DESC and then name ASC
- (NSArray*)allApps;

// provides a list of known application ports which can be shortened
- (NSArray*)appPorts;

// OMAC MIDI message handling. Call this function with every MIDI message
// the app receives. If it is an OMAC MIDI message, then this function
// will act on the message on behalf of the app. To reduce function call
// overhead, consider only calling this if the first two bytes are F0 and 1F
// using the macro defined above,
// eg: if (IS_OMAC_MIDI_MESSAGE(msg) [omac processMIDIMessage:msg:msglen];
- (void)processMIDIMessage:(unsigned char*)bytes :(unsigned short)length;

// set the delegate property to an object that conforms to the protocol
// for background updates
@property(nonatomic, assign) id<OMACApplicationRegistryDelegate> delegate;

// readonly properties from the plist
@property(nonatomic, readonly) NSString* version;
@property(nonatomic, readonly) NSString* author;
@property(nonatomic, readonly) NSString* dateUpdated;
@property(nonatomic, readonly) NSString* futureURL;

@end


// Application class - container object for applications
@interface OMACApplication : NSObject
{
    NSURL* launch_url;
}

// switch to (or launch) the app represented by the current object
- (void)launch;

// internal methods
- (id)initWithDictionary:(NSDictionary*)dic;
- (void)check_installed;

// properties that can be examined
@property(nonatomic, readonly) BOOL installed;
@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* developer;
@property(nonatomic, readonly) NSString* description;
@property(nonatomic, readonly) NSString* launchURL;
@property(nonatomic, readonly) NSString* virtualPortName;
@property(nonatomic, readonly) NSArray*  supportedPlatforms;
@property(nonatomic, readonly) float minimumCoreFoundation;
@property(nonatomic, readonly) NSString* appStoreURL;
@property(nonatomic, readonly) NSString* videoURL;
@property(nonatomic, readonly) NSInteger serialNo;
@property(nonatomic, readonly) BOOL supportsMIDISwitch;

@end

#endif
/*
 
$Log: OMACApplicationRegistry.h,v $
Revision 1.5  2014/02/05 12:39:21  nic
Update for MacOS X awareness (compiles but does nothing)

Revision 1.4  2013/12/10 14:19:33  nic
- add appPorts
- fix up function names for Xcode 5

Revision 1.3  2012/10/11 11:22:00  nic
Added support for MIDI message switching

Revision 1.2  2011/11/23 09:29:44  nic
version 3, with NLog changes

Revision 1.1.1.1  2011/11/09 12:54:47  nic
Initial release


 */
