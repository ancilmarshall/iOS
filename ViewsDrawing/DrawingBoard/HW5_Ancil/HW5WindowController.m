//
//  HW5WindowController.m
//  HW5_Ancil
//
//  Created by Ancil on 8/10/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW5WindowController.h"
#import "HW5GraphViewController.h"
#import "HW5ShapesViewController.h"
#import "HW5ArtViewController.h"

@interface HW5WindowController ()
@property (nonatomic,strong) NSViewController* viewController; //base pointer to custom view controllers
@property (weak) IBOutlet NSView *view; //view from the current custom view controllers
@property (nonatomic,strong) NSString* currentItemIdentifier; //used to avoid redundant updates if already in current toolbar option that is clicked by user
@end

@implementation HW5WindowController

NSString* const defaultGraphID = @"GraphToolbarIdentifier";
NSString* const defaultShapesID = @"ShapesToolbarIdentifier";
NSString* const defaultArtID = @"ArtToolbarIdentifier";

-(NSString*)currentItemIdentifier
{
    if (!_currentItemIdentifier)
        _currentItemIdentifier = [[NSString alloc] init];
    return _currentItemIdentifier;
}

-(id)init
{
    self = [super initWithWindowNibName:self.className];
    return self;
}

-(void)awakeFromNib
{
    [self changeViewController:defaultGraphID];
    self.currentItemIdentifier = defaultGraphID;
}

#pragma mark - Layout choices

- (IBAction)toolbarClicked:(NSToolbarItem *)sender
{
    //get the identifer (instead of the tag like the tutorial videos)
    [self changeViewController:[sender itemIdentifier]];
}

-(void)changeViewController:(NSString*) controllerName
{
    if (! [self.currentItemIdentifier isEqualTo:controllerName])
    {
        [[self.viewController view] removeFromSuperview];
        
        if ( [controllerName isEqualToString:defaultGraphID])
            self.viewController = [[HW5GraphViewController alloc] init];
        
        else if ([controllerName isEqualToString:defaultShapesID])
            self.viewController = [[HW5ShapesViewController alloc] init];
        
        else if ([controllerName isEqualToString:defaultArtID])
            self.viewController = [[HW5ArtViewController alloc] init];
        
        else
            NSLog(@"Incorrect toolbar identifier");
        
        //
        [self.view addSubview:[self.viewController view]];
        [[self.viewController view] setFrame:self.view.bounds];
        [[self.viewController view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        
        self.currentItemIdentifier = controllerName;
    }
}

@end
