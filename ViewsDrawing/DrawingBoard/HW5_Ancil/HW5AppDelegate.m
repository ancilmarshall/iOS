//
//  HW5AppDelegate.m
//  HW5_Ancil
//
//  Created by Ancil on 8/10/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW5AppDelegate.h"
#import "HW5WindowController.h"

@interface HW5AppDelegate()
@property (nonatomic,strong) HW5WindowController* windowController;
@end

@implementation HW5AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.windowController = [[HW5WindowController alloc] init];
    [self.windowController showWindow:nil];
}

@end
