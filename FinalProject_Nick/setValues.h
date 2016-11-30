//
//  setValues.h
//  FinalProject_Nick
//
//  Created by Nick Savva on 28/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface setValues : NSObject
    
    

@property (nonatomic, assign) NSInteger CCcontroller;

@property (nonatomic, assign) NSInteger value;

+ (setValues *) sharedInstance;
-(void)callSetFaders;



@end
