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

#pragma mark MidiBus protocol methods
- (void)receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT*)event {
    
    static unsigned long tick_count = 0;
    switch (event->data[0])
    {
            // start/continue
        case 0xFA :
        case 0xFB :
            // start your own transport at the timestamp of this event
            tick_count = 0;
            break;
            
            // timing tick (24 per 1/4 note)
        case 0xF8 :
            
            // engine sync point here
            
            // example - MIDI metronome
            if (!(tick_count % 24))
            {
                /*
                 // schedule MIDI metronome off/on to co-incide exactly with this with this incoming tick
                 event->length = 3;
                 event->data[0] = 0x90;
                 event->data[1] = 0x3C;
                 event->data[2] = ((tick_count % 96) == 0 ? 0x60 : 0x40);
                 midibus_send(myVirtualIndex, event);
                 NSLog(@"tick1");
                 
                 event->data[0] = 0x80;
                 event->data[2] = 0x00;
                 event->delay_ms = 20.0;
                 midibus_send(myVirtualIndex, event);
                 NSLog(@"tick2");
                 */
            }
            
            tick_count++;
            break;
    }
    
}

@end
