//
//  AppDelegate.h
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidiBusClient.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, MidiBusClientDelegate>{
    uint8_t bluetoothIndex;
    uint8_t networkIndex;
}
    
  
    
    

@property (strong, nonatomic) UIWindow *window;




@end

