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


@end
@implementation controlsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //setting properties for all sliders
    for (UISlider *fader in self.faders) {
        
        //set rotate sliders by 90 degrees (or pi/2 radians) adapted from http://www.edumobile.org/ios/a-vertical-slider-for-iphone/
        CGAffineTransform sliderRotation = CGAffineTransformIdentity;
        sliderRotation = CGAffineTransformRotate(sliderRotation, -(M_PI / 2));
        fader.transform = sliderRotation;
        //add action method to each slider
        [fader addTarget:self action:@selector(faderSend:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    
    /*Using NSTimer to call 'updateFader' method below, method is called every 0.001 seconds (1ms), so it almost essentially runs in the backround continuously
     this allows fader positions to always be updated to by 'in sync' with faders in DAW
     from: http://ajourneywithios.blogspot.co.uk/2011/03/simplified-use-of-nstimer-class-in-ios.html
     */
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateFader:) userInfo:nil repeats:YES];
    
}



#pragma mark slider methods

int sliderReleased;



 -(void)faderSend:(UISlider *)sender{
 
 int controller = 40 + [sender tag];
 
 int value = sender.value;
 
 [self faderSendMIDI:controller state:value];
 
 NSLog(@"fader send, value %f:",sender.value);
 }





-(void)updateFader:(NSTimer *) theTimer{
    
    /*

        if(UIControlEventValueChanged == FALSE){
            
            setValues *setValueClass = [setValues sharedInstance];
            
            self.fader1.value = [setValueClass value];
        }
     */
    
}






#pragma mark functions for midi

- (void)faderSendMIDI:(int)controller state:(int)value{
    
    MIDIBUS_MIDI_EVENT* fader = [MidiBusClient setupSmallEvent];
    
    fader->timestamp = 0;
    fader->length = 3; //3 byte message
    fader->data[0] = 0xB1; //cc message, channel 2
    fader->data[1] = controller; //controller no. variable
    fader->data[2] = value; //value variable, dependant on UI slider position, from 0 to 127
    
    
    [MidiBusClient sendMidiBusEvent:fader->index withEvent:fader];
    [MidiBusClient disposeSmallEvent:fader];
    
    
    
}




@end
