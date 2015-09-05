//
//  FPBlockDemoTests.m
//  FPBlockDemoTests
//
//  Created by Tim Ekl on 2015.01.10.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSArray+FPBlockExtensions.h"

@interface FPBlockDemoTests : XCTestCase

@end

@implementation FPBlockDemoTests

- (void)testIntegerDoublingWithApplication {
    NSArray *numbers = @[ @1, @2, @3 ];
    ApplierBlock doubler = ^(id anObject) {
        NSParameterAssert([anObject isKindOfClass:[NSNumber class]]);
        return @([anObject integerValue] * 2);
    };
    
    NSArray *result = [numbers arrayByPerformingBlock:doubler];
    NSArray *expected = @[ @2, @4, @6 ];
    XCTAssertEqualObjects(result, expected, @"Expected each number to double");
}

- (void)testStringDoublingWithApplication {
    NSArray *strings = @[ @"foo", @"bar", @"baz" ];
    ApplierBlock doubler = ^(id anObject) {
        NSParameterAssert([anObject isKindOfClass:[NSString class]]);
        return [NSString stringWithFormat:@"%@%@", anObject, anObject];
    };
    
    NSArray *result = [strings arrayByPerformingBlock:doubler];
    NSArray *expected = @[ @"foofoo", @"barbar", @"bazbaz" ];
    XCTAssertEqualObjects(result, expected, @"Expected each string to double");
}

- (void)testFilterNumberValue {
    NSArray *numbers = @[ @1, @10, @100, @1000 ];
    PredicateBlock isThreeDigits = ^(id anObject) {
        NSParameterAssert([anObject isKindOfClass:[NSNumber class]]);
        return (BOOL)([anObject integerValue] > 99);
    };
    
    NSArray *result = [numbers objectsPassingTest:isThreeDigits];
    NSArray *expected = @[ @100, @1000 ];
    XCTAssertEqualObjects(result, expected, @"Expected to only keep three-digit numbers");
}

- (void)testFilterStringLength {
    NSArray *names = @[ @"Tim", @"Catherine" ];
    PredicateBlock isLongEnough = ^(id anObject) {
        NSParameterAssert([anObject isKindOfClass:[NSString class]]);
        return (BOOL)([anObject length] > 5);
    };
    
    NSArray *result = [names objectsPassingTest:isLongEnough];
    NSArray *expected = @[ @"Catherine" ];
    XCTAssertEqualObjects(result, expected, @"Expected to only keep five-character names or longer");
}

@end
