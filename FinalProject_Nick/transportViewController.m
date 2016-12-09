//
//  transportViewController.m
//  FinalProject_Nick
//
//  Created by Nick Savva on 23/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "transportViewController.h"

@interface transportViewController ()


//IB outlet array for transport buttons, all buttons in view are linked to this
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *transportControls;

@end

@implementation transportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //map events to each button
    for (UIButton *transportButton in self.transportControls) {
        [transportButton addTarget:self action:@selector(transportDown:) forControlEvents:UIControlEventTouchDown];
        [transportButton addTarget:self action:@selector(transportUp:) forControlEvents:UIControlEventTouchUpInside];
        [transportButton addTarget:self action:@selector(transportUp:) forControlEvents:UIControlEventTouchUpOutside];
        [transportButton addTarget:self action:@selector(transportUp:) forControlEvents:UIControlEventTouchCancel];
    }
}


    //when transport buttons are pressed down
- (IBAction)transportDown:(id)sender{
   
    //asign unique value to each button from sender tag (sender tags are set unique in storyboard)
    int controllerno = 70 + [sender tag];
    
    //call function and send midi cc message with value 127
    [self transportSend:controllerno controllervalue:127];
    NSLog(@"CC transport control, controler no: %i ", controllerno);
    
}

    //when transport buttons are released down
- (IBAction)transportUp:(id)sender{
   
    int controllerno = 70 + [sender tag];
    
    //call function and send midi cc message with value 0
    [self transportSend:controllerno controllervalue:0];
    
    
}


#pragma mark Sending MIDI

    //function for sending MIDI CC messages which are sent when transport control buttons are pressed 
- (void)transportSend:(int)controller controllervalue:(int)value;{
    
    MIDIBUS_MIDI_EVENT* sendTransport = [MidiBusClient setupSmallEvent];
    
    sendTransport->timestamp = 0;
    sendTransport->length = 3;
    sendTransport->data[0] = 0xBF; //control change (CC) message on channel 16
    sendTransport->data[1] = controller; //controller number
    sendTransport->data[2] = value; //value (either 0 or 127)
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:sendTransport];
    [MidiBusClient sendMidiBusEvent:1 withEvent:sendTransport];
    [MidiBusClient sendMidiBusEvent:2 withEvent:sendTransport];
    [MidiBusClient disposeSmallEvent:sendTransport];
    
}

-(void)receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT *)event{
    
    
}



@end
