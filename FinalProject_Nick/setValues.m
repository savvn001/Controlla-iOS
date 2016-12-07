//
//  setValues.m
//  FinalProject_Nick
//
//  Created by Nick Savva on 28/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//


//class for setting states of objects in application from incoming MIDI data, adapted from https://www.cocoanetics.com/2009/05/the-death-of-global-variables/ and https://eencae.wordpress.com/ios-tutorials/other/passing-data-between-multiple-views/

#import "setValues.h"

@implementation setValues

@synthesize CCcontroller;
@synthesize value;
@synthesize connectionPresent = _connectionPresent;
@synthesize interfaceName = _interfaceName;


static setValues *_sharedInstance;

- (id) init
{
    if (self = [super init])
    {
        // custom initialization
    }
    return self;
}



+ (setValues *) sharedInstance
{
    if (!_sharedInstance)
    {
        _sharedInstance = [[setValues alloc] init];
    }
    
    return _sharedInstance;
}









@end
