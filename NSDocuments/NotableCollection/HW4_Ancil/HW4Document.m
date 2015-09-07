//
//  HW4Document.m
//  HW4_Ancil
//
//  Created by Ancil on 8/6/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW4Document.h"
#import "HW4NotableWindowController.h"

@interface HW4Document ()
@property (nonatomic,strong) HW4NotableWindowController* controller;
@end

@implementation HW4Document

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.controller = [[HW4NotableWindowController alloc] init];
    }
    return self;
}

//override -makeWindowControllers
-(void)makeWindowControllers
{
    [self addWindowController:self.controller];
}

#pragma mark - Document saving/loading
+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.controller.list];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.controller.list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return YES;
}

@end
