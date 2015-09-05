//
//  ViewController.m
//  BlockGitUnitTestPractice
//
//  Created by Ancil on 1/13/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "PersonData.h"

@interface PersonData ()

@end

@implementation PersonData

-(instancetype)initWithFirstName:(NSString*)fname lastName:(NSString*)lname;
{
    if (self = [super init]) {
        self.firstname = fname;
        self.lastname = lname;
    }
    return self;
}

-(BOOL)isEqual:(id)object;
{
    NSParameterAssert([object isKindOfClass:[PersonData class]]);
    PersonData* rhs = (PersonData*)object;
    
    return (self.lastname == rhs.lastname) && (self.firstname == rhs.firstname);
}

@end
