//
//  ModelData.m
//  UW_HW1_ancil
//
//  Created by Ancil on 10/2/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "ModelData.h"

@interface ModelData ()
@property(nonatomic,readwrite) NSUInteger redCount;
@property(nonatomic,readwrite) NSUInteger blueCount;
@property(nonatomic,readwrite) NSUInteger greenCount;
@property(nonatomic,readwrite) NSUInteger customCount;
@property(nonatomic,readwrite) NSUInteger randomCount;
@end

@implementation ModelData

-(instancetype) init
{
    self = [super init];
    if (self){
        [self resetCounts];
    }
    return self;
}

-(void)resetCounts
{
    self.redCount = 0;
    self.greenCount = 0;
    self.blueCount = 0;
    self.customCount = 0;
    self.randomCount = 0;
}

-(void)updateCountForColor:(NSString *)color
{
    if ([color isEqualToString:@"Red"])
        self.redCount++;
    else if ([color isEqualToString:@"Green"])
        self.greenCount++;
    else if ([color isEqualToString:@"Blue"])
        self.blueCount++;
    else if ([color isEqualToString:@"Custom"])
        self.customCount++;
    else if ([color isEqualToString:@"Random"])
        self.randomCount++;
    else
        @throw @"Unknown color for [ModelData updateCountForColor]";
    
}

@end
