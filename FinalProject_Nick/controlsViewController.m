//
//  controlsViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "controlsViewController.h"
#import "setValues.h"
#import "AppDelegate.h"

@interface controlsViewController (){
    
    
    
}



//IBoutlet collection for UIsliders to set properties, further down
@property (nonatomic, strong) IBOutletCollection(UISlider) NSArray *faders;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *muteSolo;


@end
@implementation controlsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //setting properties for all sliders
    for (UISlider *fader in self.faders) {
        
        //have to rotate faders by 90 degrees to look vertical (will look horizontal in storyboard)
        //set rotate sliders by 90 degrees (or pi/2 radians) adapted from http://www.edumobile.org/ios/a-vertical-slider-for-iphone/
        CGAffineTransform sliderRotation = CGAffineTransformIdentity;
        sliderRotation = CGAffineTransformRotate(sliderRotation, -(M_PI / 2));
        fader.transform = sliderRotation;
        //add action method to each slider
        [fader addTarget:self action:@selector(faderSend:) forControlEvents:UIControlEventValueChanged];
        [fader addTarget:self action:@selector(faderRelease:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    int j = 20; //variable for sender tag
    for(UIButton *button in self.muteSolo){
        button.tag = j; //assign sender tag to button
        j++; //increment j, so next button has sender tag that = 21 and so forth
        [button addTarget:self action:@selector(MuteSoloDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(MuteSoloUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    /*Using NSTimer to call 'updateFader' method below, method is called every 0.001 seconds (1ms), so it almost essentially runs in the backround continuously
     this allows fader positions to always be updated to by 'in sync' with faders in DAW
     from: http://ajourneywithios.blogspot.co.uk/2011/03/simplified-use-of-nstimer-class-in-ios.html
     */
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateFader:) userInfo:nil repeats:YES];
    
}



#pragma mark slider methods

//Some variables needed to control the behaviour of sliders
int value;
int newValue;
int controller;
int controllerMove = 0;

-(void)faderSend:(UISlider *)sender{
    
    //map sender tag of slider to controller variable, used later to send MIDI message
    controller = 40 + [sender tag] + controllerMove;
    
    //sender value mapped to 'value'
    value = sender.value;
    
    //call method to send MIDI
    [self faderSendMIDI:controller state:value];
    
    NSLog(@"fader send, value %f:",sender.value);
    
}

-(void)faderRelease:(UISlider *)sender{
    
    //have to be able to know when slider is released, so map value to this 'newValue' variable when slider is released
    //can check in next method if newValue == value to know when sliders are released
    newValue = value;
    
    NSLog(@"slider let go");
    
}

//move left & right,
- (IBAction)moveLeft:(UIButton *)sender {
    controllerMove++;
}

- (IBAction)moveRight:(UIButton *)sender {
    controllerMove--;
}



//updating sliders so they are automatically moved if moved in DAW
//if slider is moved in DAW, it will send out a message back to the app to update the postion of mapped slider ('remote' function in ableton)
-(void)updateFader:(NSTimer *) theTimer{
    
    //called shared instance (to receive variables from recieved MIDI method in app delegate)
    setValues *setValueClass = [setValues sharedInstance];
    
    //check if sliders released first (don't want to be updating values as slider is moved)
    if (newValue == value) {
        
        for (UISlider *currentSlider in self.faders) {
            if([setValueClass CCcontroller] == (currentSlider.tag + 40 + controllerMove)){
                currentSlider.value = [setValueClass value];
                
            }
            
        }
        
    }
    
}


#pragma mark Mute/Solo buttons

//mute & solo buttons underneath each fader
-(void)MuteSoloDown:(UISlider *)sender{
    
    int state = 0x92;
    [self muteSolo:[sender tag] state:state];
    
    NSLog(@"mute solo sender tag %i:",[sender tag]);
    
}

-(void)MuteSoloUp:(UISlider *)sender{
    
    int state = 0x82;
    [self muteSolo:[sender tag] state:state];
}

#pragma mark functions for midi

- (void)faderSendMIDI:(int)controller state:(int)value{
    
    MIDIBUS_MIDI_EVENT* fader = [MidiBusClient setupSmallEvent];
    
    fader->timestamp = 0;
    fader->length = 3; //3 byte message
    fader->data[0] = 0xB1; //cc message, channel 2
    fader->data[1] = controller; //controller no. variable
    fader->data[2] = value; //value variable, dependant on UI slider position, from 0 to 127
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:fader];
    [MidiBusClient sendMidiBusEvent:1 withEvent:fader];
    [MidiBusClient sendMidiBusEvent:2 withEvent:fader];
    [MidiBusClient disposeSmallEvent:fader];
    
    
    
}

-(void)muteSolo:(int)note state:(int)state{
    
    MIDIBUS_MIDI_EVENT* fader = [MidiBusClient setupSmallEvent];
    
    fader->timestamp = 0;
    fader->length = 3; //3 byte message
    fader->data[0] = state; //state (note on/off)
    fader->data[1] = note; //note variable
    fader->data[2] = 127; //velocity (just set to 127)
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:fader];
    [MidiBusClient sendMidiBusEvent:1 withEvent:fader];
    [MidiBusClient sendMidiBusEvent:2 withEvent:fader];
    [MidiBusClient disposeSmallEvent:fader];
    
    NSLog(@"mute/solo sent");
    
}



@end
