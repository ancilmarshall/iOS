//
//  TaskList+CustomAccessors.m
//  CoreDataDemo
//
//  Created by Tim Ekl on 2015.01.13.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "TaskList+CustomAccessors.h"

@implementation TaskList (CustomAccessors)

- (NSString *)firstLetterOfTitle;
{
    return [self.title substringToIndex:1];
}

@end
