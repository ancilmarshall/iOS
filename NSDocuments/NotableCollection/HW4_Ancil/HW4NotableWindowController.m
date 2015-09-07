//
//  HW4NotableWindowController.m
//  HW4_Ancil
//
//  Created by Ancil on 8/7/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW4NotableWindowController.h"

@interface HW4NotableWindowController()
@property (weak) IBOutlet NSTableView *masterTableView;
@property (weak) IBOutlet NSTextField *detailedViewTitle;
@property (weak) IBOutlet NSTextField *detailedViewDetails;

@property (weak) IBOutlet NSButton *removeButton;
@property (nonatomic) NSInteger selectedRow;


//other properties from public interface header file
// @property (strong,nonatomic) HW2TodoList* list;
@end

@implementation HW4NotableWindowController

-(HW2TodoList*)list
{
    if (!_list)
        _list = [[HW2TodoList alloc] init];
    
    return _list;
}

-(instancetype)init
{
    self = [super initWithWindowNibName:@"HW4NotableWindowController"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.masterTableView.delegate = self;
    self.masterTableView.dataSource = self;
    self.detailedViewTitle.delegate = self;
    self.detailedViewDetails.delegate = self;
    self.list.delegate = self;
    
    [self.masterTableView reloadData];
    [self reInitGui];
    
}

-(void)reInitGui
{
    [self.removeButton setEnabled:NO];
    [self.detailedViewTitle setEnabled:NO];
    [self.detailedViewDetails setEnabled:NO];
    self.detailedViewTitle.stringValue = @"";
    self.detailedViewDetails.stringValue = @"";
    //self.selectedRow = -1;
}

-(void)allowItemInput
{
    [self.removeButton setEnabled:YES];
    [self.detailedViewTitle setEnabled:YES];
    [self.detailedViewDetails setEnabled:YES];
}
#pragma  mark - Master view target/action

- (IBAction)addItemButtonPushed:(NSButton *)sender
{
    [self.list addItemWithTitle:@""];
    [self.masterTableView reloadData];
    [self reInitGui];
}

- (IBAction)removeItemButtonPushed:(NSButton *)sender
{
    [self.list removeItemAtIndex:self.selectedRow];
    [self.masterTableView reloadData];
    [self reInitGui];
}

- (IBAction)droppedImage:(NSImageView *)sender
{
    NSInteger index = [self.masterTableView rowForView:sender];
    HW2TodoItem* item = [self.list itemAtIndex:index];
    item.image = sender.image;
    NSIndexSet* rowIndexSet = [[NSIndexSet alloc] initWithIndex:index];
    NSIndexSet* colIndexSet = [[NSIndexSet alloc] initWithIndex:0];

    [self.masterTableView reloadDataForRowIndexes:rowIndexSet
                                    columnIndexes:colIndexSet];
    
    [self reInitGui];
}

- (IBAction)clearAllButtonPressed:(NSButton *)sender
{
    self.list = [[HW2TodoList alloc] init];
    self.list.delegate = self;
    [self.masterTableView reloadData];
    [self reInitGui];
}

- (IBAction)groceryButtonPressed:(NSButton *)sender
{
    self.list = [HW2TodoList groceryListWithDelegate:self];
    [self.masterTableView reloadData];
    [self reInitGui];
}

- (IBAction)suitcaseButtonPressed:(NSButton *)sender
{
    self.list = [HW2TodoList suitcaseListWithDelegate:self];
    [self.masterTableView reloadData];
    [self reInitGui];
}

#pragma mark - TextField delegate methods
-(void)controlTextDidChange:(NSNotification *)obj
{
    NSString* who = [[obj object] identifier];
    if ([who isEqualToString:@"DetailViewTitleIdentifier"])
    {
        [self.list setItemTitle:self.detailedViewTitle.stringValue AtIndex:self.selectedRow];
        [self.masterTableView reloadData];
    }
    else if ([who isEqualToString:@"DetailViewDetailsIdentifier"])
    {
        [self.list setItemDetail:self.detailedViewDetails.stringValue AtIndex:self.selectedRow];
        [self.masterTableView reloadData]; //TODO: not really needed
    }
    else
        NSLog(@"idendifier not found");
}

#pragma mark - Table View Delegate methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.list count];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *theCell = [tableView makeViewWithIdentifier:@"masterTableViewCell" owner:self];
    
    HW2TodoItem* item = [self.list itemAtIndex:row];
    theCell.textField.stringValue = item.title;
    theCell.imageView.image = item.image;
 
    return theCell;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    self.selectedRow = [self.masterTableView selectedRow];
    if ( self.selectedRow >= 0 && self.selectedRow < [self.list count])
    {
        self.detailedViewTitle.stringValue = [self.list itemTitleAtIndex:self.selectedRow];
        self.detailedViewDetails.stringValue = [self.list itemDetailAtIndex:self.selectedRow];
        [self allowItemInput];
    }
    else
        [self reInitGui];
}

#pragma mark - HW2ToDoListDelegate methods
-(void)todoList:(HW2TodoList*)todoList didAddItem:(HW2TodoItem*)item
{
    //doing nothing here
}
-(void)todoList:(HW2TodoList*)todoList didDeleteItem:(HW2TodoItem*)item;
{
    //doing nothing here
}

#pragma mark - NSWindow delegate methods
-(BOOL) shouldCloseDocument
{
    [self.document saveDocument:nil];
    return YES;
}

@end
