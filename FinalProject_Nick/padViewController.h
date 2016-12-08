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



//method for sending midi when buttons are pressed
- (void)padsSend:(int)note state:(int)status;

//IBactions for pads 
- (IBAction) padDown: (id) sender;
- (IBAction) padUp: (id) sender;

//Octave up & down buttons
- (IBAction)octaveUp:(UIButton *)sender;
- (IBAction)octaveDown:(UIButton *)sender;

//extra labels outside of outlet collection 
@property (weak, nonatomic) IBOutlet UILabel *xtraLabel1;
@property (weak, nonatomic) IBOutlet UILabel *xtraLabel2;

-(IBAction)chordSelect:(UIButton*)sender;



//each chord button needs to be individually adressable





//each chord has seperate function for sending MIDI
//can't start name with a number so have to put a underscore before
-(void)None;
-(void)Maj;
-(void)Min;
-(void)Dom7;
-(void)Maj7;
-(void)Min7;
-(void)mM7;
-(void)_7b5;
-(void)_7x5;
-(void)m7b5;
-(void)_7b9;
-(void)b5;
-(void)_5;
-(void)_6;
-(void)m6;
-(void)_69;
-(void)_9;
-(void)_9b5;
-(void)_9x5;
-(void)m9;
-(void)Maj9;
-(void)Add9;
-(void)_7x9;
-(void)_11;
-(void)m11;
-(void)_13;
-(void)_Maj13;
-(void)Sus2;
-(void)Sus4;
-(void)_7Sus4;
-(void)_9Sus4;
-(void)Dim7;
-(void)Aug;










@end
