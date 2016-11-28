//
//  padViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "padViewController.h"

@interface padViewController ()


@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *pianoKeys;

@end

@implementation padViewController

int padoctave = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIButton *pad in self.pianoKeys) {
        [pad addTarget:self action:@selector(padDown:) forControlEvents:UIControlEventTouchDown];
        [pad addTarget:self action:@selector(padUp:) forControlEvents:UIControlEventTouchUpInside];
        [pad addTarget:self action:@selector(padUp:) forControlEvents:UIControlEventTouchUpOutside];
        [pad addTarget:self action:@selector(padUp:) forControlEvents:UIControlEventTouchCancel];
    }
}

-(IBAction)goToKeyboard:(id)sender {
    
    
    
    //Switch view to keyboard view
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"keyboardViewController"];
    [self presentViewController: vc animated:NO completion:nil];
}

- (IBAction)goToControls:(id)sender {
    //Switch view to control view
    UIStoryboard* Main = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    UIViewController *vc = [Main instantiateViewControllerWithIdentifier: @"controlsViewController"];
    [self presentViewController: vc animated:NO completion:nil];
}






-(void)padDown:(id)sender{
    
    int note = 60 + [sender tag];
    [self transportSend:note controllervalue:0x91];
    NSLog(@"pad on");
    
}

-(void)padUp:(id)sender{
    
    int note = 60 + [sender tag];
    [self transportSend:note controllervalue:0x81];
    NSLog(@"pad off");
    
}



- (void)transportSend:(int)note controllervalue:(int)status{
    
    MIDIBUS_MIDI_EVENT* key1 = [MidiBusClient setupSmallEvent];
    
    key1->timestamp = 0;
    key1->length = 3;
    key1->data[0] = status;
    key1->data[1] = note + padoctave;
    key1->data[2] = 0x7F;
    
    [MidiBusClient sendMidiBusEvent:key1->index withEvent:key1];
    
    [MidiBusClient disposeSmallEvent:key1];
    
    
    
}

@end
