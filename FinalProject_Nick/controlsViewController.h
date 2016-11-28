//
//  controlsViewController.h
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"

@interface controlsViewController : UIViewController
 

- (void)faderSendMIDI:(int)controller state:(int)value;

- (IBAction)goToKeyboard:(id)sender;
- (IBAction)goToPads:(id)sender;


- (IBAction)faderSend:(UISlider *)sender;



@property (weak, nonatomic) IBOutlet UISlider *fader1;









@end
