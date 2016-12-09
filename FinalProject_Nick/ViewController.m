//
//  ViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


//IBoutlet collection for piano keys, learned from http://useyourloaf.com/blog/interface-builder-outlet-collections/
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *pianoKeys;

//UI images for piano imageview
@property (nonatomic, strong) UIImage *piano1;
@property (nonatomic, strong) UIImage *piano2;
@property (nonatomic, strong) UIImage *piano3;
@property (nonatomic, strong) UIImage *piano4;
@property (nonatomic, strong) UIImage *piano5;
@property (nonatomic, strong) UIImage *piano6;
@property (nonatomic, strong) UIImage *piano7;
@property (nonatomic, strong) UIImage *piano8;
@property (nonatomic, strong) UIImage *piano9;
@property (nonatomic, strong) NSMutableArray *imageArray;


@end


int pianoOctaveImage = 3;


@implementation ViewController

#pragma mark Loading

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *pianoKey in self.pianoKeys) {
        //add actions for control events to all buttons in outlet collection
        [pianoKey addTarget:self action:@selector(pianoKeyDown:) forControlEvents:UIControlEventTouchDown];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchUpInside];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchUpOutside];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchCancel];
    }
    
    //different objects for piano image
    _piano1 = [UIImage imageNamed:@"piano_piano1"];
    _piano2 = [UIImage imageNamed:@"piano_piano2"];
    _piano3 = [UIImage imageNamed:@"piano_piano3"];
    _piano4 = [UIImage imageNamed:@"piano_piano4"];
    _piano5 = [UIImage imageNamed:@"piano_piano5"];
    _piano6 = [UIImage imageNamed:@"piano_piano6"];
    _piano7 = [UIImage imageNamed:@"piano_piano7"];
    _piano8 = [UIImage imageNamed:@"piano_piano8"];
    _piano8 = [UIImage imageNamed:@"piano_piano9"];
    
    
    //set default to image of middle octave
    [_pianoImage setImage:_piano5];
    
    //make array for piano objects
    self.imageArray = [NSMutableArray arrayWithObjects:@"_piano1", @"_piano2", @"_piano3", @"_piano4", @"_piano5", nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark Piano Key Actions

//when piano keys are pressed down
- (IBAction) pianoKeyDown:(id)sender
{
    
    //generate note variable to be unique to each key (each key is identified by its sender tag which is set to be unqiue to each button, set in storyboard)
    int note = 36 + [sender tag];
    [self pianoKeys:note state:0x90];
    NSLog(@"note on");
}

- (IBAction) pianoKeyUp:(id)sender
{
    UInt8 note = 36 + [sender tag];
    [self pianoKeys:note state:0x80];
    NSLog(@"note off");
}



#pragma mark Octave Controls
//variable for controlling octave of notes sent out, initally 0, then set to +/- multiples of 12 when 'octave down' and 'octave up' are pressed
int octave = 0;

//octave up and down buttons
- (IBAction)octaveDown:(UIButton *)sender {
    
    //12 notes = 1 octave, so reduce octave by 12
    octave = octave - 12;
    
    //set image dependant on current octave
    if(octave == 0){
        [_pianoImage setImage:_piano5];
    }
    else if(octave == 12){
        [_pianoImage setImage:_piano6];
    }
    else if (octave == 24){
        [_pianoImage setImage:_piano7];
    }
    else if (octave == 36){
        [_pianoImage setImage:_piano8];
    }
    else if (octave == 48){
        [_pianoImage setImage:_piano9];
    }
    else if(octave == -12){
        [_pianoImage setImage:_piano4];
    }
    else if (octave == -24){
        [_pianoImage setImage:_piano3];
    }
    else if (octave == -36){
        [_pianoImage setImage:_piano2];
    }
    else if (octave == -48){
        [_pianoImage setImage:_piano1];
    }
    
    
}



- (IBAction)octaveUp:(UIButton *)sender {
    
    //increase octave by 12
    octave = octave + 12;
    
    if(octave == 0){
        [_pianoImage setImage:_piano5];
    }
    else if(octave == 12){
        [_pianoImage setImage:_piano6];
    }
    else if (octave == 24){
        [_pianoImage setImage:_piano7];
    }
    else if (octave == 36){
        [_pianoImage setImage:_piano8];
    }
    else if (octave == 48){
        [_pianoImage setImage:_piano9];
    }
    else if(octave == -12){
        [_pianoImage setImage:_piano4];
    }
    else if (octave == -24){
        [_pianoImage setImage:_piano3];
    }
    else if (octave == -36){
        [_pianoImage setImage:_piano2];
    }
    else if (octave == -48){
        [_pianoImage setImage:_piano1];
    }
    
    
    
}




#pragma mark Modulation and Pitch slider
//sending modulation cc message for modulation slider
- (IBAction)modulationSlider:(UISlider *)sender {
    
    //rounding slider value to an integer
    int modvalue = sender.value;
    
    
    //midibus event for sending MIDI, defined in documentation
    MIDIBUS_MIDI_EVENT* modulation = [MidiBusClient setupSmallEvent];
    
    modulation->timestamp = 0; //Timestamp, set to 0, don't need to delay anything
    modulation->length = 3; //3 byte message
    modulation->data[0] = 0xB0; //control change message
    modulation->data[1] = 0x01; //controller set to modulation
    modulation->data[2] = modvalue; //controler value
    
    
    NSLog(@"modlation slider, value: %i", modvalue);
    
    //send on all interfaces (index 0, 1 and 2)
    [MidiBusClient sendMidiBusEvent:0 withEvent:modulation];
    [MidiBusClient sendMidiBusEvent:1 withEvent:modulation];
    [MidiBusClient sendMidiBusEvent:2 withEvent:modulation];
    //dispose of event afterwards
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
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:pitch];
    [MidiBusClient sendMidiBusEvent:1 withEvent:pitch];
    [MidiBusClient sendMidiBusEvent:2 withEvent:pitch];
    [MidiBusClient disposeSmallEvent:pitch];
    
    
    
    
}






#pragma mark MIDI Events

/* - method for sending a MIDI note on/note off when piano key button is pressed
 - takes two input parameters, note value and status byte (both defined in hex)
 */

- (void)pianoKeys:(int)note state:(int)statusbyte{
    
    
    
    MIDIBUS_MIDI_EVENT* key1 = [MidiBusClient setupSmallEvent];
    
    key1->timestamp = 0;
    key1->length = 3;
    key1->data[0] = statusbyte; //status byte, for note on/note off
    key1->data[1] = note + octave; //note & octave variable
    key1->data[2] = 0x7F;
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:key1];
    [MidiBusClient sendMidiBusEvent:1 withEvent:key1];
    [MidiBusClient sendMidiBusEvent:2 withEvent:key1];
    
    [MidiBusClient disposeSmallEvent:key1];
    
    
}

- (IBAction)pitchSliderRelease:(UISlider *)sender {
    //reset slider to centre after released by user, mimicks real pitch bend wheel behaviour
    self.pitchSliderCenter.value = 64.00;
    
    int pitchvalue = sender.value;
    
    //have to send a pitch bend message with 64 so host is notified of return to center
    MIDIBUS_MIDI_EVENT* pitch = [MidiBusClient setupSmallEvent];
    
    pitch->timestamp = 0;
    pitch->length = 3; //3 byte message
    pitch->data[0] = 0xE0; //pitch bend message
    pitch->data[1] = 0x01; //LSB (7 bits) bend value
    pitch->data[2] = pitchvalue; //MSB (7 bits) bend value
    
    
    NSLog(@"pitch value slider, value: %i", pitchvalue);
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:pitch];
    [MidiBusClient sendMidiBusEvent:1 withEvent:pitch];
    [MidiBusClient sendMidiBusEvent:2 withEvent:pitch];
    [MidiBusClient disposeSmallEvent:pitch];
    
    
}



@end
