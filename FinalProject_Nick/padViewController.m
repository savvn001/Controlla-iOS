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
//outlet collection for labels that display octave number variable
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *octaveLabel;
//outlet array for chord selectors
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *chords;
//array that stores title of chords
@property (nonatomic,strong) NSMutableArray *chordArray;
//array that stores labels of chords
@property (nonatomic,strong) NSMutableArray *chordLabels;
//array that stores chords 'attached' to each pad
@property (nonatomic,strong) NSMutableArray *padChord;


@end

#pragma mark Variable Declarations
//Variables
int note; //note for MIDI message sent
int state;  //state for MIDI message sent
int padoctave = 0; //variable for octave of note sent when pads are pressed, initally 0
int octaveNo = 3; //'number' of octave, default 3
int lastPadPressed; //variable to be assigned sender tag



@implementation padViewController


#pragma mark Inital View load

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Assign control events and IBaction events to each pad
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
    
    
    
    
    
    
    //array for sending chords
    //Using arrays learnt from ->   http://rypress.com/tutorials/objective-c/data-types/nsarray
    
    /*This array stores the values of whether a pad plays a chord or 'none', all are initally set to 'none'.
     When a chord is selected for a current pad, 'none' string changes to string of selected chord (could be Dim7 for example)
     this means this chord is 'attached' to pad
     */
    self.padChord = [NSMutableArray arrayWithObjects: @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", @"None", @"None", @"None",
                     @"None", @"None", @"None",
                     @"None", @"None", nil];
    
    //each element here refers to a particular chord method (all implemented at bottom of file)
    self.chordArray = [NSMutableArray arrayWithObjects: @"None", @"Maj", @"Min",
                       @"Dom7", @"Maj7", @"Min7", @"mM7", @"_7b5",@"_7x5", @"m7b5", @"_7b9",@"b5",@"_5",@"_6",@"m6",@"_69",@"_9",@"_9b5",@"_9x5", @"m9",@"Maj9",@"Add9",@"_7x9",@"_11",@"m11",@"_13",@"_Maj13",@"Sus2",@"Sus4",@"_7Sus4",@"_9Sus4", @"Dim7", @"Aug", nil];
    
    //array of strings for labels for buttons in view
    self.chordLabels = [NSMutableArray arrayWithObjects: @"None", @"Maj", @"Min",
                        @"Dom7", @"Maj7", @"Min7", @"mM7", @"7b5",@"7#5", @"m7b5", @"7b9",@"b5",@"5",@"6",@"m6",@"6/9",@"9",@"9b5",@"9#5", @"m9",@"Maj9",@"Add9",@"7#9",@"11",@"m11",@"13",@"Maj13",@"Sus2",@"Sus4",@"7Sus4",@"9Sus4", @"Dim7", @"Aug", nil];
    
    
    //set properties for chord buttons under 'CHORDS' outlet collection,
    int n = 0; //a counter for adressing the chordArray below to set titles for buttons
    //enumerate chord button array
    for(UIButton *chordSelect in self.chords){
        
        //programatically setting labels
        NSString *title =  self.chordLabels[n];
        //add IBaction chordSelect to each button touch down
        [chordSelect addTarget:self action:@selector(chordSelect:) forControlEvents:UIControlEventTouchDown];
        //set title to be 'n-th' element of chordArray
        [chordSelect setTitle:title forState:UIControlStateNormal];
        //also set tag to be n+20
        chordSelect.tag = n + 20;
        n++;
    }
    
    
}




#pragma mark Pad Action Methods

//When pads are pressed down, send note on
-(void)padDown:(id)sender{
    
    //each pad has unique sender tag (which is an int ranging from 0-15) assigned to it in storyboard, assign sender tag of button pressed to lastPadPressed variable
    lastPadPressed = [sender tag];
    
    //note variable, mapped by sender tag of pad
    note = 36 + [sender tag];
    
    //0x91 = 'note On' in hex
    state = 0x91;
    
    
    //scan through array of chords and check if current pad has that chord attached to it
    int y = 0;
    for(NSString *item in _chordLabels){ //item 2 is current item in chordLabels, loops through
        
        
        if ([_padChord[[sender tag]] isEqualToString:[_chordArray objectAtIndex:y]]){ //check if the chord attatched to current pad in question is equal to current item in chordArray
            
            //have to set states of chord select buttons to reflect chord set to current pad
            for(UIButton *chordSelect in self.chords){
                //button with name 'item2' should be set: selected == TRUE
                if([chordSelect.titleLabel.text isEqualToString:item]){
                    chordSelect.selected = TRUE;
                }
                else{
                    //else button is deselected
                    chordSelect.selected = FALSE;
                }
            }
        }
        y++; //increment counter
    }
    
    
    //call the respective function chord function to send MIDI
    NSString *chordFunction = [_padChord objectAtIndex:[sender tag]]; //make NSstring variable reflects current chord
    NSLog(@"%@", chordFunction);
    
    //call relevant chord function by string name (from http://stackoverflow.com/questions/20400366/dynamically-call-static-method-on-class-from-string
    //call chord method by 'chordFunction' string name (chord methods listed at bottom of code)
    //this will give a warning in the in the compiler, it is possible to call a method that doesn't exist and cause a crash
    SEL selector = NSSelectorFromString(chordFunction);
    [self performSelector:selector];
    
    
    
    
    
    
    
    
}


//When pads are released down, send note off
-(void)padUp:(id)sender{
    
    note = 36 + [sender tag];
    
    state = 0x81; //Note Off Message
    
    NSString *chordFunction = [_padChord objectAtIndex:[sender tag]];
    
    //call same chord method but this time 'state' is different, so sends Note Off
    SEL selector = NSSelectorFromString(chordFunction);
    [self performSelector:selector];
    
    
}

#pragma mark Octave buttons

//octave up & down buttons
- (IBAction)octaveUp:(UIButton *)sender {
    
    //increase octave 1, (12 notes)
    padoctave = padoctave + 12;
    octaveNo++;
    NSLog(@"octave = %i:",padoctave);
    //Update labels on pads
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

#pragma mark chord select

//When you select a chord for a pad this method is called
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
    for(int j = 20; j < 54; j++){
        
        if([sender tag] == j){
            
            [_padChord replaceObjectAtIndex:lastPadPressed withObject:_chordArray[j-20]];
        }
        
    }
    
    
    
    NSLog(@"pad chords%@",_padChord);
}

#pragma mark MIDI Send Function

//function for sending MIDI, called when pads are pressed and released
- (void)padsSend:(int)note state:(int)status{
    
    MIDIBUS_MIDI_EVENT* pad1 = [MidiBusClient setupSmallEvent];
    
    pad1->timestamp = 0;
    pad1->length = 3;
    pad1->data[0] = status;
    pad1->data[1] = note + padoctave;
    pad1->data[2] = 0x7F;
    
    [MidiBusClient sendMidiBusEvent:0 withEvent:pad1];
    [MidiBusClient sendMidiBusEvent:1 withEvent:pad1];
    [MidiBusClient sendMidiBusEvent:2 withEvent:pad1];
    
    [MidiBusClient disposeSmallEvent:pad1];
    
    
    
}

#pragma mark Chord functions
//each chord that is selected for each pad will trigger one of the below method ('none' just sends a single note, ie no chord)

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

-(void)mM7{
    NSLog(@"sending mM7 chord");
}
-(void)_7b5{
    NSLog(@"sending 7b5 chord");
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+6 state:state];
    [self padsSend:note+10 state:state];
}
-(void)_7x5{
    NSLog(@"sending 7#5 chord");
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+8 state:state];
    [self padsSend:note+10 state:state];
}
-(void)m7b5{
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+6 state:state];
    [self padsSend:note+10 state:state];
}
-(void)_7b9{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+13 state:state];
}
-(void)b5{
    
}
-(void)_5{
    [self padsSend:note state:state];
    [self padsSend:note+7 state:state];
}
-(void)_6{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+9 state:state];
}
-(void)m6{
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+9 state:state];
}
-(void)_69{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+9 state:state];
    [self padsSend:note+14 state:state];
}
-(void)_9{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+14 state:state];
    
}
-(void)_9b5{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+6 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+14 state:state];
}
-(void)_9x5{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+8 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+14 state:state];
}
-(void)m9{
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+14 state:state];
}
-(void)Maj9{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+11 state:state];
    [self padsSend:note+14 state:state];
}
-(void)Add9{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+14 state:state];
}
-(void)_7x9{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+15 state:state];
}
-(void)_11{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+14 state:state];
    [self padsSend:note+17 state:state];
    
}
-(void)m11{
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+9 state:state];
    [self padsSend:note+14 state:state];
    [self padsSend:note+17 state:state];
}
-(void)_13{
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+7 state:state];
    [self padsSend:note+10 state:state];
    [self padsSend:note+14 state:state];
    [self padsSend:note+17 state:state];
    [self padsSend:note+20 state:state];
    
}
-(void)_Maj13{
}
-(void)Sus2{
}
-(void)Sus4{
    
}
-(void)_7Sus4{
}
-(void)_9Sus4{
}
-(void)Dim7{
    [self padsSend:note state:state];
    [self padsSend:note+3 state:state];
    [self padsSend:note+6 state:state];
    [self padsSend:note+9 state:state];
}
-(void)Aug{
    NSLog(@"sending Aug chord");
    [self padsSend:note state:state];
    [self padsSend:note+4 state:state];
    [self padsSend:note+8 state:state];
}



@end
