//
//  BirthdayData.m
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/13/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "BirthdayData.h"
#import "BirthdayDataItem.h"

#pragma mark - BirthayData

@interface BirthdayData()
@property (nonatomic,strong) NSMutableArray* birthdays;
@end

@implementation BirthdayData

/*
 * Singleton method to share one instance of BirthdayData across the application
 */
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

//init method
- (instancetype)init
{
    self = [super init];
    if (self) {
        _birthdays = [NSMutableArray new];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'";
        
        //initialize birthdays with dummy data
        [_birthdays addObject:[[BirthdayDataItem alloc]
                              initWithFirstName:@"Will"
                              lastName:@"Smith"
                              birthday: [dateFormatter dateFromString:@"1968-09-25"]]];
        
        [_birthdays addObject:[[BirthdayDataItem alloc]
                               initWithFirstName:@"Matt"
                               lastName:@"Damon"
                               birthday: [dateFormatter dateFromString:@"1970-08-08"]]];
    }
    
    [self.birthdays sortUsingSelector:@selector(birthdayDataItemComparator:)];

    return self;
}

#pragma mark - BirthdayData methods
-(NSInteger)count
{
    return [self.birthdays count];
}

- (void)addFirstName:(NSString*)first lastName:(NSString*)last birthday:(NSDate*)date;
{
    [self.birthdays addObject:[[BirthdayDataItem alloc]
                               initWithFirstName:first
                                        lastName:last
                                        birthday:date]];
    [self.birthdays sortUsingSelector:@selector(birthdayDataItemComparator:)];
}

- (void)removeObjectAtIndex:(NSInteger)index;
{
    [self.birthdays removeObjectAtIndex:index];
    [self.birthdays sortUsingSelector:@selector(birthdayDataItemComparator:)];
}

- (NSString*) nameAtIndex:(NSInteger)index;
{
    BirthdayDataItem* item = (BirthdayDataItem*)self.birthdays[index];
    return item.fullname;
}

- (NSString*) dateAtIndex:(NSInteger)index;
{
    BirthdayDataItem* item = (BirthdayDataItem*)self.birthdays[index];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:item.birthday]];
}

@end
