//
//  ViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *pianoKeys;



@end

@implementation ViewController

#pragma mark Loading

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (UIButton *pianoKey in self.pianoKeys) {
        [pianoKey addTarget:self action:@selector(pianoKeyDown:) forControlEvents:UIControlEventTouchDown];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchUpInside];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchUpOutside];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchCancel];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Switching Views

-(IBAction)goToPads:(id)sender {
    
    //Switch View to Pads View, learned from from 'How to switch storybard views programmatically' https://www.youtube.com/watch?v=QhNdvCE9jVg
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"padViewController"];
    [self presentViewController: vc animated:NO completion:nil];
}


- (IBAction)goToControls:(id)sender {
    //Switch View to controls View
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"controlsViewController"];
    [self presentViewController: vc animated:NO completion:nil];

}







#pragma mark sending midi
    //variable for controlling octave of notes sent out, initally 0, then set to +/- multiples of 12 when 'octave down' and 'octave up' are pressed
    int octave = 0;

- (IBAction) pianoKeyDown:(id)sender
{
    int note = 60 + [sender tag];
    [self pianoKeys:note state:0x90];
    NSLog(@"note on");
}
 
- (IBAction) pianoKeyUp:(id)sender
    {
        UInt8 note = 60 + [sender tag];
        [self pianoKeys:note state:0x80];
        NSLog(@"note off");
    }

- (IBAction)octaveDown:(UIButton *)sender {
    octave = octave - 12;
    if (octave <  -60){
        octave = -60;
    }
   
}

- (IBAction)octaveUp:(UIButton *)sender {
    octave = octave + 12;
    if (octave > 60){
        octave = 60;
    }
}

    //sending modulation cc message for modulation slider
- (IBAction)modulationSlider:(UISlider *)sender {
    
    //rounding slider value to an integer
    int modvalue = sender.value;
    
    
    //midibus event
    MIDIBUS_MIDI_EVENT* modulation = [MidiBusClient setupSmallEvent];
    
    modulation->timestamp = 0;
    modulation->length = 3; //3 byte message
    modulation->data[0] = 0xB0; //control change message
    modulation->data[1] = 0x01; //controller set to modulation
    modulation->data[2] = modvalue; //controler value
    
    
    NSLog(@"modlation slider, value: %i", modvalue);
    
    [MidiBusClient sendMidiBusEvent:modulation->index withEvent:modulation];
    [MidiBusClient disposeSmallEvent:modulation];
}




    //pitch bend slider
- (IBAction)pitchSliderSend:(UISlider *)sender {
    
    int pitchvalue = sender.value;
    
    
    //midibus event
    MIDIBUS_MIDI_EVENT* pitch = [MidiBusClient setupSmallEvent];
    
    pitch->timestamp = 0;
    pitch->length = 3; //3 byte message
    pitch->data[0] = 0xE0; //pitch bend message
    pitch->data[1] = 0x01; //LSB (7 bits) bend value
    pitch->data[2] = pitchvalue; //MSB (7 bits) bend value
    
    
    NSLog(@"pitch value slider, value: %i", pitchvalue);
    
    [MidiBusClient sendMidiBusEvent:pitch->index withEvent:pitch];
    [MidiBusClient disposeSmallEvent:pitch];
    
    
    
    
}

- (IBAction)pitchSliderRelease:(UISlider *)sender {
    //reset slider to centre after released by user
    self.pitchSliderCenter.value = 64.00;
    
    int pitchvalue = sender.value;
    
    MIDIBUS_MIDI_EVENT* pitch = [MidiBusClient setupSmallEvent];
    
    pitch->timestamp = 0;
    pitch->length = 3; //3 byte message
    pitch->data[0] = 0xE0; //pitch bend message
    pitch->data[1] = 0x01; //LSB (7 bits) bend value
    pitch->data[2] = pitchvalue; //MSB (7 bits) bend value
    
    
    NSLog(@"pitch value slider, value: %i", pitchvalue);
    
    [MidiBusClient sendMidiBusEvent:pitch->index withEvent:pitch];
    [MidiBusClient disposeSmallEvent:pitch];
    
    
    
    
}




- (void)receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT*)event {
    // do something with a received MIDI event
    NSLog(@"just recieved some midi");
    //[MidiBusClient sendMidiBusEvent:event->index withEvent:event];
}







#pragma mark Button Methods

    /* - method for sending a MIDI note on/note off when piano key button is pressed
       - takes two input parameters, note value and status byte (both defined in hex)
     */

- (void)pianoKeys:(int)note state:(int)statusbyte{
    
   
    
    MIDIBUS_MIDI_EVENT* key1 = [MidiBusClient setupSmallEvent];
    
    key1->timestamp = 0;
    key1->length = 3;
    key1->data[0] = statusbyte;
    key1->data[1] = note + octave;
    key1->data[2] = 0x7F;
    
    [MidiBusClient sendMidiBusEvent:key1->index withEvent:key1];
    
    [MidiBusClient disposeSmallEvent:key1];

    
}

//[self pianoKeys:0x3C state:0x80];
//[self pianoKeys:0x3C state:0x90];


@end
