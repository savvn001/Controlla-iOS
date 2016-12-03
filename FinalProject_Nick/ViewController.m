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
    // Do any additional setup after loading the view, typically from a nib.
    for (UIButton *pianoKey in self.pianoKeys) {
        [pianoKey addTarget:self action:@selector(pianoKeyDown:) forControlEvents:UIControlEventTouchDown];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchUpInside];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchUpOutside];
        [pianoKey addTarget:self action:@selector(pianoKeyUp:) forControlEvents:UIControlEventTouchCancel];
    }
    
    _piano1 = [UIImage imageNamed:@"piano_piano1"];
    _piano2 = [UIImage imageNamed:@"piano_piano2"];
    _piano3 = [UIImage imageNamed:@"piano_piano3"];
    _piano4 = [UIImage imageNamed:@"piano_piano4"];
    _piano5 = [UIImage imageNamed:@"piano_piano5"];
    _piano6 = [UIImage imageNamed:@"piano_piano6"];
    _piano7 = [UIImage imageNamed:@"piano_piano7"];
    _piano8 = [UIImage imageNamed:@"piano_piano8"];
    _piano8 = [UIImage imageNamed:@"piano_piano9"];
    
   
    
    [_pianoImage setImage:_piano5];
    
    
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
    
    //generate note variable to be unique to each key (each key is identified by its sender tag which is set to be unqiue to each button)
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


#pragma Modulation and Pitch slider
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
    //NSLog(@"just recieved some midi");
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


@end
