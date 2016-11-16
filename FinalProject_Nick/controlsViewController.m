//
//  controlsViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "controlsViewController.h"

@interface controlsViewController ()

@end

@implementation controlsViewController

- (IBAction)goToKeyboard:(id)sender {
//Switch view to keyboard view
UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"keyboardViewController"];
[self presentViewController: vc animated:NO completion:nil];
}

- (IBAction)goToPads:(id)sender {
    //Switch view to pads view
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"padViewController"];
    [self presentViewController: vc animated:NO completion:nil];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
