//
//  controlsViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "controlsViewController.h"



@interface controlsViewController ()

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
    
  //UISlider *fader1 = (UISlider*)[self.view viewWithTag:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToKeyboard:(id)sender {
    //Switch view to keyboard view
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"keyboardViewController"];
    [self presentViewController: vc animated:NO completion:nil];
}

#pragma mark Switching Views

- (IBAction)goToPads:(id)sender {
    //Switch view to pads view
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"padViewController"];
    [self presentViewController: vc animated:NO completion:nil];
    
}


#pragma mark slider methods

-(void)faderSend:(UISlider *)sender{
    
    int controller = 40 + [sender tag];
    
    int value = sender.value;
    
    [self faderSendMIDI:controller state:value];
    
    NSLog(@"fader send, value %f:",sender.value);
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
