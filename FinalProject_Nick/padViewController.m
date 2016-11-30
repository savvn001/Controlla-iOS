//
//  padViewController.m
//  FinalProject_Nick
//
//  Created by Nicholas on 12/11/2016.
//  Copyright © 2016 Nick Savva. All rights reserved.
//

#import "padViewController.h"



@interface padViewController ()

//IB oulet collection for buttons
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *pads;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *octaveLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *chords;
@property (nonatomic,strong) NSMutableArray *chordArray;
@property (nonatomic,strong) NSMutableArray *padChord;


@end

//variable for octave of note sent when pads are pressed, initally 60
int note;
int state;
int padoctave = 0;
int octaveNo = 3;
int lastPadPressed;

//array for sending chords
//array stuff ->  http://rypress.com/tutorials/objective-c/data-types/nsarray





@implementation padViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Assign control events and IBaction events to each button in outlet collcetion
    for (UIButton *pad  in self.pads) {
        [pad addTarget:self action:@selector(padDown:) forControlEvents:UIControlEventTouchDown];
        [pad addTarget:self action:@selector(padUp:) forControlEvents:UIControlEventTouchUpInside];
        [pad addTarget:self action:@selector(padUp:) forControlEvents:UIControlEventTouchUpOutside];
        [pad addTarget:self action:@selector(padUp:) forControlEvents:UIControlEventTouchCancel];
    }
    
    //Set initial states of octave labels
    for(UILabel *octaveLabel in self.octaveLabel){
        octaveLabel.text = [NSString stringWithFormat: @"%d", 3];
    }
    self.xtraLabel1.text = [NSString stringWithFormat: @"%d", 4 ];
    self.xtraLabel2.text = [NSString stringWithFormat: @"%d", 4 ];
    
    //set properties for chord buttons under 'CHORDS' outlet collection, add action 'ChordSelect' for control event Touch down
    for(NSString *chordLabels in _chordArray){
        for(UIButton *chordSelect in self.chords){
            [chordSelect addTarget:self action:@selector(chordSelect:) forControlEvents:UIControlEventTouchDown];
            [chordSelect setTitle:chordLabels forState:normal];
            
        }
    }
    
    //array for sending chords
    //array stuff ->  http://rypress.com/tutorials/objective-c/data-types/nsarray
    
    self.padChord = [NSMutableArray arrayWithObjects: @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", nil];
    
    self.chordArray = [NSMutableArray arrayWithObjects: @"None", @"Maj", @"Min",
                       @"Dom7", @"Maj7", @"Min7", @"mM7", @"7b5",@"7x5", @",m7b5", @"_7b9",@"b5",@"_5",@"_6",@"m6",@"_69",@"_9",@"_9b5",@"_9x5", @",m9",@"Maj9",@"Add9",@"_7x9",@"_11",@"m11",@"_13",@"_Maj13",@"Sus2",@"Sus4",@"_7Sus4",@"_9Sus4", @"Dim7", @"Aug", nil];
    
    
}





//When pads are pressed down, send note on
-(void)padDown:(id)sender{
    
    lastPadPressed = [sender tag];
    
    note = 38 + [sender tag];
    
    state = 0x91;
    
    
    //scan through array of chords and check whether current pad pressed has a chord set to it in the padChord array, if so set chord buttons to represent that
    
    for(NSString *item2 in _chordArray){
        
        if ([_padChord[[sender tag]] isEqualToString:item2]){
            for(UIButton *chordSelect in self.chords){
                //button with name 'item2' should be set: selected == TRUE
                if([chordSelect.titleLabel.text isEqualToString:item2]){
                    chordSelect.selected = TRUE;
                }
                else{
                    //else button is deselected
                    chordSelect.selected = FALSE;
                }
            }
        }
    }
    
    //call the respective function chord function to send MIDI
    NSString *chordFunction = [_padChord objectAtIndex:[sender tag]];
    NSLog(@"%@", chordFunction);
    
    //call relevant chord function by string name (from http://stackoverflow.com/questions/20400366/dynamically-call-static-method-on-class-from-string
    SEL selector = NSSelectorFromString(chordFunction);
    [self performSelector:selector];
    
    
    
    
    
    
    
    
}

//When pads are released down, send note off
-(void)padUp:(id)sender{
    
    note = 38 + [sender tag];
    state = 0x81;
    
    NSString *chordFunction = [_padChord objectAtIndex:[sender tag]];
    
    SEL selector = NSSelectorFromString(chordFunction);
    [self performSelector:selector];
    
    
}

//octave up & down buttons
- (IBAction)octaveUp:(UIButton *)sender {
    padoctave = padoctave + 12;
    octaveNo++;
    NSLog(@"octave = %i:",padoctave);
    for(UILabel *octaveLabel in self.octaveLabel){
        octaveLabel.text = [NSString stringWithFormat: @"%d", octaveNo];
    }
    self.xtraLabel1.text = [NSString stringWithFormat: @"%d", octaveNo + 1 ];
    self.xtraLabel2.text = [NSString stringWithFormat: @"%d", octaveNo + 1 ];
    
    
}

- (IBAction)octaveDown:(UIButton *)sender {
    
    padoctave = padoctave - 12;
    octaveNo--;
    NSLog(@"octave = %i:",padoctave);
    for(UILabel *octaveLabel in self.octaveLabel){
        octaveLabel.text = [NSString stringWithFormat: @"%d", octaveNo];
    }
    self.xtraLabel1.text = [NSString stringWithFormat: @"%d", octaveNo + 1 ];
    self.xtraLabel2.text = [NSString stringWithFormat: @"%d", octaveNo + 1 ];
    
    
}

//action for chord select buttons
-(IBAction)chordSelect:(UIButton*)sender{
    
    
    
    //set all other buttons to deselected
    for(UIButton *chordSelect in self.chords){
        chordSelect.selected = FALSE;
    }
    
    //toggle button pressed
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
    
    
    //loop through, check sender tag and replace the right element in the 'padchord' array with the correct value from 'chords' array
    //'lastPadPressed' is sender tag of most recent pad pressed, this corresponds exactly to an element in the 'padChord' array
    for(int j = 20; j < 26; j++){
        
        if([sender tag] == j){
            
            [_padChord replaceObjectAtIndex:lastPadPressed withObject:_chordArray[j-20]];
        }
        
    }
    
    
    
    NSLog(@"pad chords%@",_padChord);
}



//function for sending MIDI, called when pads are pressed and released
- (void)padsSend:(int)note state:(int)status{
    
    MIDIBUS_MIDI_EVENT* pad1 = [MidiBusClient setupSmallEvent];
    
    pad1->timestamp = 0;
    pad1->length = 3;
    pad1->data[0] = status;
    pad1->data[1] = note + padoctave;
    pad1->data[2] = 0x7F;
    
    [MidiBusClient sendMidiBusEvent:pad1->index withEvent:pad1];
    
    [MidiBusClient disposeSmallEvent:pad1];
    
    
    
}

#pragma mark Chord functions
//each chord that is selected for each pad will trigger one of the below method (none just sends a single note, ie no chord)

-(void)None{
    
    NSLog(@"sending none");
    [self padsSend:note state:state];
}

-(void)Maj{
    
    NSLog(@"sending major chord");
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
}

-(void)Min{
    
    NSLog(@"sending minor chord");
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+7 state:state];
    
}

-(void)Dom7{
    
    NSLog(@"sending 7 chord");
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    
}
-(void)Maj7{
    
    NSLog(@"sending Maj7 chord");
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+11 state:state];
    
    
}
-(void)Min7{
    
    NSLog(@"sending Min7 chord");
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    
    
}


@end
