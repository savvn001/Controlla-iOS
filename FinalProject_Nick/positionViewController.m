//
//  positionViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 23/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "positionViewController.h"
#import "setValues.h"

@interface positionViewController ()

@end

@implementation positionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*timer so interfaceNameLabel method can be almost essentially running in the backround
     this is so if the connection status changes, for example if you disconnect from network and switch to bluetooth, label
     will update it's status
     */
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(interfaceNameLabel:) userInfo:nil repeats:YES];
    
    
}

-(void)interfaceNameLabel:(NSTimer *) timer{
    
    //call shared instance
    setValues *setValueClass = [setValues sharedInstance];
    
    
    //set the label to display the name of the interface
    self.interfaceLabel.text = [setValueClass interfaceName];
    
    //check if connection is present
    if([setValueClass connectionPresent] == YES){
        //set circle to be green
        UIImage *green = [UIImage imageNamed: @"circle_red.png"];
        [_connectionIndicator setImage:green];
        
    }
    
    
}





@end

