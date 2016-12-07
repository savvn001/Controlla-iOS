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
  

//method for sending midi when keys are pressed, more information in implemenation of method in ViewController.m
- (void)pianoKeys:(int)note state:(int)statusbyte;



- (IBAction) pianoKeyDown: (id) sender;
- (IBAction) pianoKeyUp: (id) sender;

- (IBAction)octaveDown:(UIButton *)sender;
- (IBAction)octaveUp:(UIButton *)sender;

- (IBAction)modulationSlider:(UISlider *)sender;

- (IBAction)pitchSliderSend:(UISlider *)sender;
- (IBAction)pitchSliderRelease:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISlider *pitchSliderCenter;
@property (weak, nonatomic) IBOutlet UIImageView *pianoImage;










@end

