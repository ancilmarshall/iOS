//
//  Greeter.m
//  UWTestDemo
//
//  Created by Tim Ekl on 2015.01.07.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "Greeter.h"

@implementation Greeter

- (NSString *)helloMessageForName:(NSString *)name;
{
    name = name ?: @"World";
    return [NSString stringWithFormat:@"Hello, %@!", name];
}

@end
