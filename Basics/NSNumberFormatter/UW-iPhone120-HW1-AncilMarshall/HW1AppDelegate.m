//
//  HW1AppDelegate.m
//  UW-iPhone120-HW1-AncilMarshall
//
//  Created by Ancil on 7/8/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW1AppDelegate.h"

@interface HW1AppDelegate()

//outlets
@property (weak) IBOutlet NSTextField *numberEnteredLabel;
@property (weak) IBOutlet NSMatrix *numberFormatPicker;
@property (weak) IBOutlet NSTextField *numberEnteredTextField;

@property (weak) IBOutlet NSTextField *speechTextField;
@property (weak) IBOutlet NSButton *speakButton;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSTextField *currentWordLabel;
@property (weak) IBOutlet NSSegmentedControl *voicePicker;
@property (weak) IBOutlet NSButton *lotrTextButton;
@property (weak) IBOutlet NSButton *colbertTextButton;

@property (weak) IBOutlet NSLevelIndicator *indicator_a;
@property (weak) IBOutlet NSLevelIndicator *indicator_e;
@property (weak) IBOutlet NSLevelIndicator *indicator_i;
@property (weak) IBOutlet NSLevelIndicator *indicator_o;
@property (weak) IBOutlet NSLevelIndicator *indicator_u;

@property (weak) IBOutlet NSTextField *analyzerTextField;

//private properties
@property (nonatomic, strong) NSNumberFormatter* stringFromNumberFormatter;
@property (nonatomic, strong) NSSpeechSynthesizer* speech;
@property (nonatomic, strong) NSString* lotr_str;

@end


@implementation HW1AppDelegate

#pragma mark - Number Tab

// lazy instantiation
-(NSNumberFormatter*)stringFromNumberFormatter
{
    if (!_stringFromNumberFormatter)
    {
        _stringFromNumberFormatter = [[NSNumberFormatter alloc] init];
    }
    return _stringFromNumberFormatter;
}

-(NSSpeechSynthesizer*)speech
{
    if (!_speech)
    {
        _speech = [[NSSpeechSynthesizer alloc] init];
    }
    return _speech;
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //set initial number format given initial application window
    [self setNumberFormatForRow:self.numberFormatPicker.selectedRow];
    self.speech.delegate = (id)self;
    
    
    [self.stopButton setEnabled:NO];
    self.currentWordLabel.stringValue = @"";
    
    self.lotr_str = @"In the mythical world of Middle-Earth, many thousands of years ago, several powerful rings were made and given to the heads of each state: three rings for the Elven-kings, seven for the Dwarf-lords and nine for Mortal Men. Unknown to them, however, the Dark Lord Sauron had secretly forged an additional ring, a master containing the power to rule the others.";

}


/* -----------------------------------------------------------------------------
 * parseNumber - handle event when user enters a number in text field
 * ---------------------------------------------------------------------------*/
- (IBAction)parseNumber:(NSTextField *)sender
{
    
    [self updateNumberEnteredLabel:sender];
    NSLog(@"Number Value: %@\n",sender.stringValue);

}

/* -----------------------------------------------------------------------------
 * parseSlider - handle event when user changes the slider value
 * ---------------------------------------------------------------------------*/
- (IBAction)parseSlider:(NSSlider *)sender
{
    [self updateNumberEnteredLabel:sender];
    self.numberEnteredTextField.stringValue = sender.stringValue;
    
    NSLog(@"Slider Value: %ld\n",(long)([sender.stringValue integerValue]));
}

/* -----------------------------------------------------------------------------
 * choseNumberFormat - update the number format based on user's choice
 * ---------------------------------------------------------------------------*/
- (IBAction)chooseNumberFormat:(NSMatrix *)sender
{
    [self setNumberFormatForRow:sender.selectedRow];
    [self updateNumberEnteredLabel:self.numberEnteredTextField];
    
    NSLog(@"Radio: Row %ld, Column %ld\n",
          sender.selectedRow,sender.selectedColumn);
}

/* -----------------------------------------------------------------------------
 * updateNumberEnteredLabel - update GUI label with number based on format
 *  Parameter is NSControl which is the base class of NSTextField and NSSlider
 * ---------------------------------------------------------------------------*/
- (void) updateNumberEnteredLabel:(NSControl*)obj
{
    //always convert from string to number using the decimal style
    NSNumberFormatter* numFromStringFormatter = [[NSNumberFormatter alloc]init];
    numFromStringFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber* num = [numFromStringFormatter numberFromString:obj.stringValue];
    
    if ( num ){
        NSString* str = [self.stringFromNumberFormatter stringFromNumber:num];
        self.numberEnteredLabel.stringValue = str;
    }
}

/* -----------------------------------------------------------------------------
 * update the formatter's number style given the row of the radio checkboxes
 * ---------------------------------------------------------------------------*/
-(void) setNumberFormatForRow:(NSInteger)row
{
    switch (row) {
        case 0:
            self.stringFromNumberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
            break;
            
        case 1:
            self.stringFromNumberFormatter.numberStyle = NSNumberFormatterScientificStyle;
            break;
            
        case 2:
            self.stringFromNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            break;
            
        default:
            break;
    }
}

#
# pragma mark - Text Speech Tab
#

/* -----------------------------------------------------------------------------
 * speakText - handle event to start speaking text
 * ---------------------------------------------------------------------------*/
- (IBAction)speakText:(NSButton *)sender {
    
    NSString* str = self.speechTextField.stringValue;
    if ( ![str isEqualToString:@""] ){
        [self.speakButton setEnabled:NO];
        [self.stopButton setEnabled:YES];
        [self.voicePicker setEnabled:NO];
        [self.lotrTextButton setEnabled:NO];
        [self.colbertTextButton setEnabled:NO];
        
        [self.speech startSpeakingString:self.speechTextField.stringValue];
    }
}

/* -----------------------------------------------------------------------------
 * stopSpeaking - handle event to stop speaking text
 * ---------------------------------------------------------------------------*/
- (IBAction)stopSpeakingText:(NSButton *)sender {
    
    [self.speech stopSpeaking];
    [self.speakButton setEnabled:YES];
    [self.stopButton setEnabled:NO];
    [self.voicePicker setEnabled:YES];
    [self.lotrTextButton setEnabled:YES];
    [self.colbertTextButton setEnabled:YES];
    self.currentWordLabel.stringValue = @"";

}

/* -----------------------------------------------------------------------------
 * speechSynthesizer:willSpeakWord:ofString: - get word that is about to be
 *   spoken and update the "Current Word" label
 * ---------------------------------------------------------------------------*/
-(void) speechSynthesizer:(NSSpeechSynthesizer *)sender
            willSpeakWord:(NSRange)characterRange
                 ofString:(NSString *)string
{
    self.currentWordLabel.stringValue =
        [string substringWithRange:characterRange];;
}

/* -----------------------------------------------------------------------------
 * speechSynthesizer:didFinishSpeaking - update GUI when speech is complete
 * ---------------------------------------------------------------------------*/
-(void) speechSynthesizer:(NSSpeechSynthesizer *)sender
        didFinishSpeaking:(BOOL)finishedSpeaking
{
    if (finishedSpeaking)
    {
        [self stopSpeakingText:nil];
    };
}

/* -----------------------------------------------------------------------------
 * chooseLOTRText - enter the pre-defined LOTR text
 * ---------------------------------------------------------------------------*/
- (IBAction)chooseLOTRText:(NSButton *)sender {
    self.speechTextField.stringValue = self.lotr_str;
}

/* -----------------------------------------------------------------------------
 * chooseLOTRText - choose a random quote by Stephen Colbert
 * ---------------------------------------------------------------------------*/
- (IBAction)chooseRandomColbertText:(NSButton *)sender {
    
    NSString* str1 = @"Contraception leads to more babies being born out of wedlock, the exact same way that fire extinguishers cause fires.";
    
    NSString* str2 = @"Why would we go to war on women? They don't have any oil.";
    
    NSString* str3 = @"Wikipedia is the first place I go when I'm looking for knowledge... or when I want to create some.";
    
    NSString* str4 = @"If Obama can force you to get health insurance just by calling it a tax, than there is nothing to stop him from making you gay marry an illegal immigrant wearing a condom on a hydroponic pot farm powered by solar energy.";
    
    NSString* str5 = @"I've long been against illegal aliens, partly because they distract us from an even bigger threat: real aliens.";
    
    NSArray* quotes = @[str1,str2,str3,str4,str5];
    unsigned index = arc4random() % [quotes count];
    self.speechTextField.stringValue = [quotes objectAtIndex:index];
}

/* -----------------------------------------------------------------------------
 * chooseSpeechVoice - pick the synthesizer voice from the GUI
 * ---------------------------------------------------------------------------*/
- (IBAction)chooseSpeechVoice:(NSSegmentedControl *)sender {
    NSInteger index = sender.selectedSegment;
    NSString* str = [self getSpeechVoiceForIndex:index];
    [self.speech setVoice:str];
}

/* -----------------------------------------------------------------------------
 * getSpeechVoiceForIndex: - lookup the synthesizer voice given index
 * ---------------------------------------------------------------------------*/
- (NSString*)getSpeechVoiceForIndex:(NSInteger)index
{
    NSArray* voiceArray = @[
                @"com.apple.speech.synthesis.voice.Agnes",
                @"com.apple.speech.synthesis.voice.Ralph",
                @"com.apple.speech.synthesis.voice.Bruce",
                @"com.apple.speech.synthesis.voice.Fred",
                @"com.apple.speech.synthesis.voice.Kathy"
                ];
    return [voiceArray objectAtIndex:index];
}


# pragma mark - Feeling Lucky Tab

/* -----------------------------------------------------------------------------
 * analyzeText - analyze the text when the button is pressed
 * ---------------------------------------------------------------------------*/
- (IBAction)analyzeText:(NSButton *)sender {
    
    NSString* str = self.analyzerTextField.stringValue;
    if ( ![str isEqualToString:@""])
    {
        [self analyzeTextForString:str];
    }
}


/* -----------------------------------------------------------------------------
 * analyzeText - analyze the text when the button is pressed
 * ---------------------------------------------------------------------------*/
-(void) analyzeTextForString:(NSString*)text
{
    
    NSArray* wordlist = [text componentsSeparatedByString:@" "];
    NSUInteger maxWords = [wordlist count];
    NSUInteger count_a = 0;
    NSUInteger count_e = 0;
    NSUInteger count_i = 0;
    NSUInteger count_o = 0;
    NSUInteger count_u = 0;

    
    NSCharacterSet* set_a = [NSCharacterSet characterSetWithCharactersInString:@"a"];
    NSCharacterSet* set_e = [NSCharacterSet characterSetWithCharactersInString:@"e"];
    NSCharacterSet* set_i = [NSCharacterSet characterSetWithCharactersInString:@"i"];
    NSCharacterSet* set_o = [NSCharacterSet characterSetWithCharactersInString:@"o"];
    NSCharacterSet* set_u = [NSCharacterSet characterSetWithCharactersInString:@"u"];

    for (NSString* word in wordlist) {
        
        NSRange range_a = [word rangeOfCharacterFromSet:set_a];
        if (range_a.length > 0){
            count_a++;
        }

        NSRange range_e = [word rangeOfCharacterFromSet:set_e];
        if (range_e.length > 0){
            count_e++;
        }

        NSRange range_i = [word rangeOfCharacterFromSet:set_i];
        if (range_i.length > 0){
            count_i++;
        }

        NSRange range_o = [word rangeOfCharacterFromSet:set_o];
        if (range_o.length > 0){
            count_o++;
        }

        NSRange range_u = [word rangeOfCharacterFromSet:set_u];
        if (range_u.length > 0){
            count_u++;
        }
    }
    
    double pct_a = ( (double)count_a/ (double)maxWords) * 100;
    double pct_e = ( (double)count_e/ (double)maxWords) * 100;
    double pct_i = ( (double)count_i/ (double)maxWords) * 100;
    double pct_o = ( (double)count_o/ (double)maxWords) * 100;
    double pct_u = ( (double)count_u/ (double)maxWords) * 100;
    
    self.indicator_a.maxValue = 100;
    [self.indicator_a setDoubleValue:pct_a];
    [self.indicator_e setDoubleValue:pct_e];
    [self.indicator_i setDoubleValue:pct_i];
    [self.indicator_o setDoubleValue:pct_o];
    [self.indicator_u setDoubleValue:pct_u];
}

/* -----------------------------------------------------------------------------
 * chooseLOTRText - enter the pre-defined LOTR text
 * ---------------------------------------------------------------------------*/
- (IBAction)chooseLotr_luckyTab:(NSButton *)sender {
    self.analyzerTextField.stringValue = self.lotr_str;
}

// clear text
- (IBAction)clearText_luckyTab:(NSButton *)sender {
    self.analyzerTextField.stringValue = @"";

}

@end
