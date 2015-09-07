//
//  BirthdayData.h
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/13/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BirthdayData : NSObject
+ (instancetype)sharedInstance;
- (NSInteger) count;
- (void)addFirstName:(NSString*)first lastName:(NSString*)last birthday:(NSDate*)date;
- (void) removeObjectAtIndex:(NSInteger)index;
- (NSString*) nameAtIndex:(NSInteger)index;
- (NSString*) dateAtIndex:(NSInteger)index;
@end
