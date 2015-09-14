//
//  TapeEquilibriumTests.m
//  TapeEquilibriumTests
//
//  Created by Ancil on 9/14/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface TapeEquilibriumTests : XCTestCase

@end

@implementation TapeEquilibriumTests

int sum(NSArray* A) {
    int sum = 0;
    
    for (NSNumber* elem in A) {
        sum = sum + (int)[elem integerValue];
    }
    
    return sum;
}


int minArrayValue(NSArray* A){
    
    int minimum = INT32_MAX;
    
    for (NSNumber* elem in A) {
        
        int num = (int)[elem integerValue];
        if (num < minimum) {
            minimum = num;
        }
    }
    
    return minimum;
}

int solution(NSMutableArray *A)
{

    NSInteger count = A.count;
    NSMutableArray* diffs = [NSMutableArray new];
    
    for (NSInteger i = 0; i < count; i++){
        
        NSArray* first = [A subarrayWithRange:NSMakeRange(0, i)];
        NSArray* second = [A subarrayWithRange:NSMakeRange(i, count-i)];
        [diffs addObject:@(abs( sum(first) - sum(second)))];
        
    }
    
    return minArrayValue([NSArray arrayWithArray:diffs]);
}


- (void)testMin {
    NSMutableArray* A = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4,@3]];
    int result = minArrayValue(A);
    int expected = 1;
    XCTAssert(result == expected, @"minArray is not working as expected");
    
}

- (void)testSum {
    
    NSMutableArray* A = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4,@3]];
    int result = sum(A);
    int expected = 13;
    XCTAssert(result == expected, @"sum is not working as expected");
    
}

- (void)testSolution {

    NSMutableArray* A = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4,@3]];
    int result = solution(A);
    int expected = 1;
    
    XCTAssert(result == expected, @"Incorrect Result");
}



@end
