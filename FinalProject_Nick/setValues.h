//
//  setValues.h
//  FinalProject_Nick
//
//  Created by Nick Savva on 28/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface setValues : NSObject
    
    
/*these two are integers that get pushed from the received MIDI method in the app delegate to the controls view controller
 in order to update the value of faders
 */
@property (nonatomic, assign) NSInteger CCcontroller;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger connectionPresent;

@property (nonatomic, copy) NSString* interfaceName;

+ (setValues *) sharedInstance;




@end
