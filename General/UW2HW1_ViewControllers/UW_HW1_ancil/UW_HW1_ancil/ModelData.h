//
//  ModelData.h
//  UW_HW1_ancil
//
//  Created by Ancil on 10/2/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelData : NSObject
@property(nonatomic,readonly) NSUInteger redCount;
@property(nonatomic,readonly) NSUInteger blueCount;
@property(nonatomic,readonly) NSUInteger greenCount;
@property(nonatomic,readonly) NSUInteger customCount;
@property(nonatomic,readonly) NSUInteger randomCount;
-(void)updateCountForColor:(NSString*)color;
-(void)resetCounts;
@end
