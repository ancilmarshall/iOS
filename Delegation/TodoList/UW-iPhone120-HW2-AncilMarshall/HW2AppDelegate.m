//
//  HW2AppDelegate.m
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW2AppDelegate.h"
#import "HW2TodoItem.h"
#import "HW2TodoList.h"

@interface HW2AppDelegate()
@property (weak) IBOutlet NSTextField *todoItemTextField;
@property (nonatomic,strong) HW2TodoList* itemList;
@property (weak) IBOutlet NSButton *allowDuplicateCheckBox;
@property (weak) IBOutlet NSTextField *numberOfItemsLabel;
@property (weak) IBOutlet NSTextField *todoListTexField;
@property (weak) IBOutlet NSButton *addItemButton;
@property (weak) IBOutlet NSButton *deleteItemButton;

@end

@implementation HW2AppDelegate

//initialized controller
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.addItemButton setEnabled:NO];
    [self.deleteItemButton setEnabled:NO];
    self.itemList = [[HW2TodoList alloc] init];
    self.itemList.delegate = self;
    [self.allowDuplicateCheckBox setState:self.itemList.allowDuplicates];
    self.window.delegate = self;
    self.todoItemTextField.delegate = self;
}

//update model and view when user want to add an item.
//Note: view gets updated through the delegate method
- (IBAction)addItem:(NSButton *)sender {
    NSString* title = self.todoItemTextField.stringValue;
    if (![title isEqualToString:@""])
        [self.itemList addItemWithTitle:title];
}

//update model and view when user want to add an item.
//Note: view gets updated through the delegate method
- (IBAction)deleteItem:(NSButton *)sender {
    NSString* title = self.todoItemTextField.stringValue;
    if (![title isEqualToString:@""])
        [self.itemList removeItemWithTitle:title];
}

//update model and view when user clicks this checkbox
- (IBAction)allowDuplicates:(NSButton *)sender {
    
    //check state from the view, then update the model
    NSInteger state = [self.allowDuplicateCheckBox state];
    if (state == NSOnState)
        self.itemList.allowDuplicates = YES;
    else
        self.itemList.allowDuplicates = NO;
    
    //update Buttons based on todoitemTextField and new state
    [self controlTextDidChange:nil];
}

//update view
-(void)updateGui
{
    [self.addItemButton setEnabled:NO];
    [self.deleteItemButton setEnabled:NO];

    self.numberOfItemsLabel.stringValue =
        [NSString stringWithFormat:@"%d Items",(int)[self.itemList itemCount]];
    NSString* str = [self.itemList description];
    self.todoListTexField.stringValue = str;
    self.todoItemTextField.stringValue=@"";
    [self allowDuplicates:nil];
}

//convienience pre-defined lists
- (IBAction)enterGroceryList:(NSButton*)sender
{
    self.itemList = [HW2TodoList groceryListWithDelegate:self];
    [self updateGui];
}

//convienience pre-defined lists
- (IBAction)enterSuitcaseList:(NSButton *)sender {
    
    self.itemList = [HW2TodoList suitcaseListWithDelegate:self];
    [self updateGui];
    
}

#pragma mark - Delegate methods
-(void)todoList:(HW2TodoList*)todoList didAddItem:(HW2TodoItem*)item
{
    [self updateGui];
}

-(void)todoList:(HW2TodoList*)todoList didDeleteItem:(HW2TodoItem*)item
{
    [self updateGui];
}

-(void)windowDidBecomeKey:(NSNotification *)notification
{
    [self updateGui];
}

//update view each time text changes
-(void)controlTextDidChange:(NSNotification *)obj
{
    NSString* str = self.todoItemTextField.stringValue;
    
    if ( [str length])
    {
        [self.addItemButton setEnabled:YES];
        if ( [self.itemList hasItemWithTitle:str])
        {
            [self.deleteItemButton setEnabled:YES];
            if ( !self.itemList.allowDuplicates )
                [self.addItemButton setEnabled:NO];
        }
        else
            [self.deleteItemButton setEnabled:NO];
    }
    else
        [self.addItemButton setEnabled:NO];

}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    if ( [self.addItemButton isEnabled] )
        [self addItem:nil];
}

@end
