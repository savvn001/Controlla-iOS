//
//  navigationViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 29/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "navigationViewController.h"
//detecting whether on iPad or iPhone (storyboards are different), from http://stackoverflow.com/questions/10167221/ios-detect-if-user-is-on-an-ipad
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface navigationViewController ()

@end

@implementation navigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Switchings views programmatically, learned from from 'How to switch storybard views programmatically' https://www.youtube.com/watch?v=QhNdvCE9jVg
- (IBAction)goToKeyboard:(UIButton *)sender {
    
    if ( IDIOM == IPAD) {
        //Switch view to keyboard view, have to have an if statement to check if on iPhone or iPad, storyboards are different
        UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"keyboardViewController"];
        [self presentViewController: vc animated:NO completion:nil];
        
    } else {
        UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"keyboardViewController"];
        [self presentViewController: vc animated:NO completion:nil];
    }
    
}

- (IBAction)goToPads:(UIButton *)sender {
    
    if ( IDIOM == IPAD ) {
        //switch to pads view
        UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"padViewController"];
        [self presentViewController: vc animated:NO completion:nil];
    } else {
        UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"padViewController"];
        [self presentViewController: vc animated:NO completion:nil];
    }
    
}

- (IBAction)goToMixer:(UIButton *)sender {
    
    if ( IDIOM == IPAD ) {
        //Switch View to controls View
        UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"controlsViewController"];
        [self presentViewController: vc animated:NO completion:nil];
    } else {
        UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
        UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"controlsViewController"];
        [self presentViewController: vc animated:NO completion:nil];
    }
    
   
}
@end
