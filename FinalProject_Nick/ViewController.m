//
//  ViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark Loading

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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


- (void)receivedMidiBusClientEvent:(MIDIBUS_MIDI_EVENT*)event {
    // do something with a received MIDI event
    NSLog(@"just recieved some midi m8");
    //[MidiBusClient sendMidiBusEvent:event->index withEvent:event];
}


//finger pressed
- (IBAction)playsomeMIDIoff:(UIButton *)sender {
    
    NSLog(@"note on..");
    
    MIDIBUS_MIDI_EVENT* key1 = [MidiBusClient setupSmallEvent];
    
    key1->timestamp = 0;
    key1->length = 3;
    key1->data[0] = 0x90;
    key1->data[1] = 0x3C;
    key1->data[2] = 0x78;
    
    eMidiBusStatus status = [MidiBusClient sendMidiBusEvent:key1->index withEvent:key1];
    
    [MidiBusClient disposeSmallEvent:key1];
    
    
    
    
}


    //finger removed
- (IBAction)playsomeMIDI:(UIButton *)sender {
    
    
    NSLog(@"note off..");
    
    MIDIBUS_MIDI_EVENT* key1 = [MidiBusClient setupSmallEvent];
    
    key1->timestamp = 0;
    key1->length = 3;
    key1->data[0] = 0x80;
    key1->data[1] = 0x3C;
    key1->data[2] = 0x78;
    
    eMidiBusStatus status = [MidiBusClient sendMidiBusEvent:key1->index withEvent:key1];
    
    [MidiBusClient disposeSmallEvent:key1];
    
}












@end
