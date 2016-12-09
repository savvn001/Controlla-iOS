//
//  positionViewController.h
//  FinalProject_Nick
//
//  Created by Nicholas on 23/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"


@interface positionViewController : UIViewController{
    NSTimer *timer;
}



@property (weak, nonatomic) IBOutlet UILabel *interfaceLabel;

@property (strong, nonatomic) IBOutlet UIImageView *connectionIndicator;
@property (strong, nonatomic) IBOutlet UIButton *bluetoothEnable;


- (IBAction)bluetoothAd:(id)sender;
- (IBAction)helpButton:(id)sender;



@end
