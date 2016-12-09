//
//  positionViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 23/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "positionViewController.h"
#import "setValues.h"


#if !(TARGET_IPHONE_SIMULATOR)
// CoreAudioKit not available on simulator
#import <CoreAudioKit/CoreAudioKit.h>
#endif

@interface positionViewController ()

@end

@implementation positionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*timer so interfaceNameLabel method can be almost essentially running in the backround
     this is so if the connection status changes, for example if you disconnect from network and switch to bluetooth, label
     will update it's status
     */
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(interfaceNameLabel:) userInfo:nil repeats:YES];
    
    
}

-(void)interfaceNameLabel:(NSTimer *) timer{
    
    //call shared instance
    setValues *setValueClass = [setValues sharedInstance];
    
    
    //set the label to display the name of the interface
    self.interfaceLabel.text = [setValueClass interfaceName];
    
    //check if WIFI connection is present
    if([setValueClass networkPresent] == YES){
        //set image to filled wifi icon
        UIImage *wifion = [UIImage imageNamed: @"Wi-Fi Filled.png"];
        [_connectionIndicator setImage:wifion];
        
    } else if ([setValueClass networkPresent] == NO){
        //set image to wifi icon
        UIImage *wifioff = [UIImage imageNamed: @"Wi-Fi.png"];
        [_connectionIndicator setImage:wifioff];
        
    }
    
    //check if bluetooth connection is present
    if([setValueClass bluetoothPresent] == YES){
        //set image to filled icon if bluetooth connection is present
        UIImage *bluetoothON = [UIImage imageNamed: @"Bluetooth 2 Filled.png"];
        [_bluetoothEnable setBackgroundImage:bluetoothON forState:UIControlStateNormal];
        
    } else if ([setValueClass bluetoothPresent] == NO){
        //set image the unfilled icon if not present
        UIImage *bluetoothOFF = [UIImage imageNamed: @"Bluetooth 2_3.png"];
        [_bluetoothEnable setBackgroundImage:bluetoothOFF forState:UIControlStateNormal];

        
    }
    
    
    
    
    
}


#pragma mark Bluetooth

- (void)doneAction:(id)sender

{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)bluetoothAd:(id)sender {
   
    /*This method advertises bluetooth availability to host computer
     called when bluetooth icon is pressed, uses CABTMIDILocalPeripheralViewController view controller object
     part of Core Audio Framework which brings up a menu to enable the device to be discoverable to a mac.
     
     Apple Q&A 'Adding bluetooth LE MIDI Support' was used for this section https://developer.apple.com/library/content/qa/qa1831/_index.html
     
     It is however not available in simulator (cannot simulate bluetooth) so will only be usable when compiled onto a device,
     have to add a check below to only run outside of simulator
     */
    
#if !(TARGET_IPHONE_SIMULATOR)
    CABTMIDILocalPeripheralViewController *viewController = [CABTMIDILocalPeripheralViewController new];
    
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    
    
    // this will present a view controller as a popover in iPad and modal VC on iPhone
    
    viewController.navigationItem.rightBarButtonItem =
    
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
     
                                                  target:self
     
                                                  action:@selector(doneAction:)];
    
    
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    
    
    
    UIPopoverPresentationController *popC = navController.popoverPresentationController;
    
    popC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    popC.sourceRect = [sender frame];
    
    
    
    UIButton *button = (UIButton *)sender;
    
    popC.sourceView = button.superview;
    
    
    
    [self presentViewController:navController animated:YES completion:nil];
#endif
    
}


@end



