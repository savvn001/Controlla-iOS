//
//  padViewController.h
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"

@interface padViewController : UIViewController{
    

}
 //Button to switch to keyboard view
-(IBAction)goToKeyboard:(id)sender;
- (IBAction)goToControls:(id)sender;


//method for sending midi when buttons are pressed
- (void)transportSend:(int)note controllervalue:(int)status;

- (IBAction) padDown: (id) sender;
- (IBAction) padUp: (id) sender;




@end
