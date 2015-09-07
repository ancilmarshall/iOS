//
//  HW3Document.m
//  HW3_ancil
//
//  Created by Ancil on 7/26/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW3Document.h"
#import "HW3PersonProfile.h"

@interface HW3Document()
@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *addressTextField;
@property (weak) IBOutlet NSTextField *notesTextField;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) NSWorkspace* workspace;

@end

@implementation HW3Document

#pragma mark - Initialization and Updates

- (id)init
{
    self = [super init];
    if (self) {
        _personProfile = [HW3PersonProfile new];
        _workspace = [NSWorkspace sharedWorkspace];
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"HW3Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    self.nameTextField.delegate = self;
    self.addressTextField.delegate = self;
    self.notesTextField.delegate = self;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

-(void)updateGui
{
    self.nameTextField.stringValue = self.personProfile.name;
    self.addressTextField.stringValue = self.personProfile.address;
    self.notesTextField.stringValue = self.personProfile.notes;
    self.imageView.image = self.personProfile.image;
}

#pragma mark - Saving and Loading

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.personProfile];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.personProfile = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return YES;
}


#pragma mark - Text Field Actions

- (IBAction)enterName:(NSTextField *)sender {
    self.personProfile.name = sender.stringValue;
}

- (IBAction)enterAddress:(NSTextField *)sender {
    self.personProfile.address = sender.stringValue;
}

- (IBAction)enterNotes:(NSTextField *)sender {
    self.personProfile.notes = sender.stringValue;
}

- (IBAction)dropNewImage:(NSImageView *)sender {
    self.personProfile.image = sender.image;
}

#pragma make - URL & Application Launching

- (IBAction)searchGoogleMap:(NSButton *)sender {
    
    NSString* str = self.addressTextField.stringValue;
    NSArray* arr = [str componentsSeparatedByString:@" "];
    NSString* urlsuffix = [arr componentsJoinedByString:@"+"];
    NSString* urlbase = @"http://www.google.com/maps/place/";
    NSURL* url = [NSURL URLWithString:[urlbase stringByAppendingString:urlsuffix]];
    [self.workspace openURL:url];
}

- (IBAction)searchBingMap:(NSButton *)sender {
    NSString* str = self.addressTextField.stringValue;
    NSArray* arr = [str componentsSeparatedByString:@" "];
    NSString* urlsuffix = [arr componentsJoinedByString:@"%20"];
    NSString* urlbase = @"http://www.bing.com/maps/?sty=r&where1=";
    NSURL* url = [NSURL URLWithString:[urlbase stringByAppendingString:urlsuffix]];
    [self.workspace openURL:url];
}

#pragma mark - Delegate Methods

-(void)controlTextDidChange:(NSNotification *)notification
{
    id obj = [notification object];
    
    // update the model data as user types since he can save at any time
    if (obj == self.nameTextField)
        [self enterName:obj];
    else if (obj == self.addressTextField)
        [self enterAddress:obj];
    else if (obj == self.notesTextField)
        [self enterNotes:obj];
}

// my attempt at entering the Return key has not worked as yet
//-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
//{
//    BOOL result = NO;
//    if (commandSelector == @selector(insertNewline:)) {
//        
//        [textView insertNewlineIgnoringFieldEditor:self];
//        
//        result = YES;
//    }
//    return result;
//}

-(void)windowDidBecomeKey:(NSNotification *)notification
{
    [self updateGui];
}

#pragma mark - Pre-programmed Data

- (IBAction)loadEiffelTower:(NSButton *)sender {
    [self loadEiffelTowerData];
    [self updateGui];
}

- (IBAction)loadArcDeTriomphe:(NSButton *)sender {
    [self loadArcDeTriompheData];
    [self updateGui];
}

- (IBAction)loadSacreCoeur:(NSButton *)sender {
    [self loadSacreCoeurData];
    [self updateGui];
}

-(void)loadEiffelTowerData
{
    self.personProfile.name = @"Eiffel Tour";
    self.personProfile.address = @"5 Avenue Anatole France 75007 Paris, France";
    self.personProfile.notes = @"Constructed in 1889";
    self.personProfile.image = [NSImage imageNamed:@"eiffel.JPG"];
}

-(void)loadArcDeTriompheData
{
    self.personProfile.name = @"Arc de Triomphe";
    self.personProfile.address = @"Place Charles de Gaulle 75008 Paris";
    self.personProfile.notes = @"Constructed in 1836";
    self.personProfile.image = [NSImage imageNamed:@"arc.JPG"];
}

-(void)loadSacreCoeurData
{
    self.personProfile.name = @"Sacre Coeur";
    self.personProfile.address = @"35 Rue du Chevalier de la Barre 75018 Paris";
    self.personProfile.notes = @"Constructed in 1914";
    self.personProfile.image = [NSImage imageNamed:@"sacrecoeur.JPG"];

}


@end
