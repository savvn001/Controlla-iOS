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
    


//Button for switching View to Pads View
-(IBAction)goToPads:(id)sender;

//button for switching view to controls view
- (IBAction)goToControls:(id)sender;



- (IBAction)playsomeMIDI:(UIButton *)sender;
- (IBAction)playsomeMIDIoff:(UIButton *)sender;



@end

