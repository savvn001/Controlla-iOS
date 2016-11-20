//
//  ViewController.h
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"

@interface ViewController : UIViewController
    <MidiBusClientDelegate>

//method for sending midi when keys are pressed, more information in implemenation of method in ViewController.m
- (void)pianoKeys:(int)note state:(int)statusbyte;


//Button for switching View to Pads View
-(IBAction)goToPads:(id)sender;

//button for switching view to controls view
- (IBAction)goToControls:(id)sender;

- (IBAction) pianoKeyDown: (id) sender;
- (IBAction) pianoKeyUp: (id) sender;

- (IBAction)octaveDown:(UIButton *)sender;
- (IBAction)octaveUp:(UIButton *)sender;









@end

