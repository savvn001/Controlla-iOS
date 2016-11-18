//
//  SetupViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 17/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "SetupViewController.h"


@interface SetupViewController ()

@end

@implementation SetupViewController

#pragma Initatiating Connection with Host

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MidiBusClient startWithApp:@"NickDAWCotrol" andDelegate:self];
    NSLog(@"MIDI Bus Client started");
    self.statusLabel.text = @"MIDI Bus Client Started";
}

// this delegate method is called every time there is a change in the // MIDI world; add/remove ports or network connect/disconnect
- (void)handleMidiBusClientNotification:(uint8_t)type {
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
    // do something with a received MIDI event
    NSLog(@"just recieved some midi m8");
    //[MidiBusClient sendMidiBusEvent:event->index withEvent:event];
}

@end
