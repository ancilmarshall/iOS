//
//  BirthdayDataItem.h
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/15/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BirthdayDataItem : NSObject
@property (nonatomic,strong) NSString* firstname;
@property (nonatomic,strong) NSString* lastname;
@property (nonatomic,strong) NSString* fullname;
@property (nonatomic,strong) NSDate* birthday;

- (instancetype)initWithFirstName:(NSString*)first
                         lastName:(NSString*)last
                         birthday:(NSDate*)date NS_DESIGNATED_INITIALIZER;

- (NSComparisonResult) birthdayDataItemComparator:(BirthdayDataItem*)other;

@end
