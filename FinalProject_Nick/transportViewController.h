//
//  transportViewController.h
//  FinalProject_Nick
//
//  Created by Nick Savva on 23/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"

@interface transportViewController : UIViewController
 <MidiBusClientDelegate>


//method for sending midi when buttons are pressed
- (void)transportSend:(int)controller controllervalue:(int)value;

- (IBAction) transportDown: (id) sender;
- (IBAction) transportUp: (id) sender;









@end
