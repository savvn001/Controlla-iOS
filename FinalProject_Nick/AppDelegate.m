//
//  AppDelegate.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreMIDI/CoreMIDI.h>
#import "setValues.h"

/*
 APPLICATION NOTES:
 
 -For this project an external library was used to handle MIDI functionality.
 Called 'MidiBus', from https://audeonic.com/midibus/
 The library handles the 'heavy lifting' of using the core MIDI framework, so focus can be put on the 'higher level' aspects,
 ie. actually sending & recieving MIDI
 
 -App layout works best on iPad Retina & iPhone 5s
 
 -Connection can to mac be simulated while running simulator, by enabling network session on Mac utilites > Audio MIDI setup > MIDI Studio > Network, and enable session, 'iphone simulator' should appear.
 
 -Bluetooth connectioon will only be available when running on physical iOS device (cannot simulate bluetooth)
 
 */


@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //start midi bus library
    [MidiBusClient startWithApp:@"Controlla" andDelegate:self];
    
    NSLog(@"MIDI Bus Client started");
    
    return YES;
    
    
    
}

void mbs_coremidi_get_refs(uint8_t index, MIDIEndpointRef* input, MIDIEndpointRef* output);

//set dual mode (can receive and send MIDI)
- (eMidiBusVirtualMode) virtualMidiBusMode {
    
    return eMidiBusVirtualModeDual;
    
}



// this delegate method is called every time there is a change in connections to the app, for example an interface connected or disconnected
//the skeleton for this method is from the MidiBus library documentation which is included in the project .zip file (documentation.html)
- (void)handleMidiBusClientNotification:(uint8_t)type {
    
    uint8_t myVirtualIndex = [MidiBusClient getMidiBusOwnInterfaceIndex];
    
    
    // use internal MidiBus function to get CoreMIDI endpoint references
    MIDIEndpointRef CoreMIDI_ref_input;
    MIDIEndpointRef CoreMIDI_ref_output;
    mbs_coremidi_get_refs(myVirtualIndex, &CoreMIDI_ref_input, &CoreMIDI_ref_output);
    
    // adjust CoreMIDI to get loopbacked virtual events early
    MIDIObjectSetIntegerProperty(CoreMIDI_ref_input, kMIDIPropertyAdvanceScheduleTimeMuSec, 1);
    
    //call shared instance
    setValues *setValueClass = [setValues sharedInstance];
    
    // create a static query object which we can reuse time and time again
    // that won't get de-alloced by ARC by making a strong reference
    // this query gets all interfaces; you can get subsets of the interfaces
    // by using a different filter value - see midibus.h for #defines for this
    static MidiBusInterfaceQuery* query = nil;
    if (query == nil)
        query = [[MidiBusInterfaceQuery alloc]
                 initWithFilter:MIDIBUS_INTERFACE_FILTER_ALL_INTERFACES];
    NSArray* interfaces = [query getInterfaces];
    
    
    
    //scan through the interaces array
    for (MidiBusInterface* obj in interfaces)
    {
        
        
        MIDIBUS_INTERFACE* interface = obj->interface;
        
        
        NSLog(@"interface name %s:",interface->ident);
        NSLog(@"interface type %u:",interface->type);
        
        //        //get interface name and assign name to string
        //        NSString* nameOfInterface = [NSString stringWithFormat:@"%s",interface->ident];
        //        //set name of interface to string, passed to label in positionViewController class
        //        [setValueClass setInterfaceName:nameOfInterface];
        
        if(interface->type == 1 && interface->network_connections == YES){
            setValueClass.networkPresent = YES;
            [setValueClass setInterfaceName:@"Network"];
            
        }
        else if(interface->type == 1 && interface->network_connections == NO)
        {
            setValueClass.networkPresent = NO;
            [setValueClass setInterfaceName:@"None"];
        }
        
        if(interface->type == 0){
            setValueClass.bluetoothPresent = YES;
            NSString* nameOfInterface = [NSString stringWithFormat:@"%s",interface->ident];
            //set name of interface to string, passed to label in positionViewController class
            [setValueClass setInterfaceName:nameOfInterface];
        }
        else{
            setValueClass.bluetoothPresent = NO;
            
        }
        
        
    }
    
    
}



#pragma mark Receiving MIDI

//When any MIDI data is recieved, this method is called
- (void)receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT*)event {
    
    setValues *setValueClass = [setValues sharedInstance];
    
    
    // set to listen to all MIDI channels (set default to only listen to channel 1)
    int map = MIDIBUS_CHANNEL_OMNI;
    [MidiBusClient setMidiBusChannels:map];
    
    //print values of incoming MIDI data, useful for debugging
    NSLog(@"received midi");
    NSLog(@"data 0 = %i",event->data[0]);
    NSLog(@"data 1 = %i",event->data[1]);
    NSLog(@"data 2 = %i",event->data[2]);
    
    //NSLog(@"interface recieved on %i",index);
    
    //if Control change on channel 2 is recieved
    if(event->data[0] == 0xB1)
    {
        
        //map the incoming cc number and value to the variables in the shared instance - to be pushed to 'controlsViewController'
        setValueClass.CCcontroller = event->data[1];
        setValueClass.value = event->data[2];
        
        
        NSLog(@"cc value from ableton = %i", event->data[2]);
        
        
    }
    
    
    
}



#pragma mark

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
