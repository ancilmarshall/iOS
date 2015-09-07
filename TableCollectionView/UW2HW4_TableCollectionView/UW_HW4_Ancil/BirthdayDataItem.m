//
//  BirthdayDataItem.m
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/15/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "BirthdayDataItem.h"

@implementation BirthdayDataItem
- (instancetype)initWithFirstName:(NSString*)first
                         lastName:(NSString*)last
                         birthday:(NSDate*)date;
{
    self = [super init];
    if (self) {
        // trim leadng and trailing punctuation marks
        first = [first
                      stringByTrimmingCharactersInSet:
                      [NSCharacterSet punctuationCharacterSet]];
        
        last = [last
                     stringByTrimmingCharactersInSet:
                     [NSCharacterSet punctuationCharacterSet]];
        
        // trim leading and trailing whitespaces
        first = [first
                      stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
        last = [last
                     stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
        
        _firstname = first;
        _lastname = last;
        
        //titlize the first and last names
        NSRange range = NSMakeRange(0, 1);
        if ( _firstname.length !=0)
        {
            _firstname =
            [_firstname stringByReplacingCharactersInRange:range
                                                withString:[_firstname substringWithRange:range].capitalizedString];
        }
        
        if ( _lastname.length != 0)
        {
            _lastname =
            [_lastname stringByReplacingCharactersInRange:range
                                               withString:[_lastname substringWithRange:range].capitalizedString];
        }
        
        //construct fullname
        if (_firstname.length == 0 && _lastname.length !=0){
            _fullname = _lastname;
        } else {
            _fullname = [NSString stringWithFormat:@"%@ %@",_firstname,_lastname];
        }
        
        _birthday = date;
        
    }
    
    return self;
}

/*
 * A comparator to sort BirthdayDataItem by fullname
 */
- (NSComparisonResult) birthdayDataItemComparator:(BirthdayDataItem*)other
{
    NSComparisonResult compResult =
    [self.fullname caseInsensitiveCompare:other.fullname];
    
    return compResult;
}

@end
