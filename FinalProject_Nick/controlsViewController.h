//
//  controlsViewController.h
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"
#import "AppDelegate.h"

@interface controlsViewController : UIViewController {
    NSTimer *timer;
}
 

- (void)faderSendMIDI:(int)controller state:(int)value;
- (void)muteSolo:(int)note state:(int)state;



- (IBAction)faderSend:(UISlider *)sender;
- (IBAction)faderRelease:(UISlider *)sender;

- (IBAction)MuteSoloDown:(UISlider *)sender;
- (IBAction)MuteSoloUp:(UISlider *)sender;

- (IBAction)moveLeft:(UIButton *)sender;
- (IBAction)moveRight:(UIButton *)sender;










@end
