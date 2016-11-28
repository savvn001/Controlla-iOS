//
//  SetupViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 17/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "SetupViewController.h"
#import <CoreMIDI/CoreMIDI.h>


@interface SetupViewController (){
    
    //uint8_t myVirtualIndex;
}


@end

@implementation SetupViewController



#pragma Initatiating Connection with Host

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //start midi bus library
    [MidiBusClient startWithApp:@"NickDAWCotrol" andDelegate:self];
    
    NSLog(@"MIDI Bus Client started");
    self.statusLabel.text = @"MIDI Bus Client Started";
    
    
}

void mbs_coremidi_get_refs(uint8_t index, MIDIEndpointRef* input, MIDIEndpointRef* output);

// this delegate method is called every time there is a change in the // MIDI world; add/remove ports or network connect/disconnect
- (void)handleMidiBusClientNotification:(uint8_t)type {
    
    uint8_t myVirtualIndex = [MidiBusClient getMidiBusOwnInterfaceIndex];
    
    // use internal MidiBus function to get CoreMIDI endpoint references
    MIDIEndpointRef CoreMIDI_ref_input;
    MIDIEndpointRef CoreMIDI_ref_output;
    mbs_coremidi_get_refs(myVirtualIndex, &CoreMIDI_ref_input, &CoreMIDI_ref_output);
    
    // adjust CoreMIDI to get loopbacked virtual events early
    MIDIObjectSetIntegerProperty(CoreMIDI_ref_input, kMIDIPropertyAdvanceScheduleTimeMuSec, 1);
    
    // set DUAL mode
    midibus_set_virtual_mode(MIDIBUS_VIRTUAL_MODE_DUAL);
    
    
    
    // create a static query object which we can reuse time and time again // that won't get de-alloced by ARC by making a strong reference // this query gets all interfaces; you can get subsets of the interfaces // by using a different filter value - see midibus.h for #defines for this
    static MidiBusInterfaceQuery* query = nil;
    if (query == nil)
        query = [[MidiBusInterfaceQuery alloc]
                 initWithFilter:MIDIBUS_INTERFACE_FILTER_ALL_INTERFACES];
    NSArray* interfaces = [query getInterfaces];
    // now do something with those interfaces
    //NSLog(@"array: %@", interfaces);
    
    for (MidiBusInterface* obj in interfaces)
    {
        MIDIBUS_INTERFACE* interface = obj->interface;
        // do something with the interface
        NSLog(@"Interface name : %s\n", interface->ident);
        NSLog(@"Interface type :%us\n", interface->type);
        NSLog(@"Interface type :%us\n", interface->mode);
        NSLog(@"Interface index :%us\n", interface->index);
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Receiving MIDI

    //When any MIDI data is recieved, this method is called
- (void)receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT*)event {
    
    // set to listen to all MIDI channels (set default to only listen to channel 1)
    int map = MIDIBUS_CHANNEL_OMNI;
    [MidiBusClient setMidiBusChannels:map];
    
    //print values of incoming MIDI data, useful for debugging
    NSLog(@"received midi");
    NSLog(@"data 1 = %i",event->data[0]);
    NSLog(@"data 2 = %i",event->data[1]);
    NSLog(@"data 3 = %i",event->data[2]);
    
    
    
    
    
    if(event->data[0] == 0xB1)
    {
        NSLog(@"cc value from ableton = %i", event->data[2]);
        //fadervalue = event->data[2];
        
        
    }
    
    
    
}

@end
