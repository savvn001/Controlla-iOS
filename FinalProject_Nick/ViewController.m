//
//  ViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(IBAction)goToPads:(id)sender {
    
    //Switch View to Pads View, learned from from 'How to switch storybard views programmatically' https://www.youtube.com/watch?v=QhNdvCE9jVg
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"padViewController"];
    [self presentViewController: vc animated:NO completion:nil];
}


- (IBAction)goToControls:(id)sender {
    //Switch View to controls View
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"controlsViewController"];
    [self presentViewController: vc animated:NO completion:nil];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
