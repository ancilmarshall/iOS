//
//  BlockGitUnitTestPracticeTests.m
//  BlockGitUnitTestPracticeTests
//
//  Created by Ancil on 1/13/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PersonData.h"

@interface BlockGitUnitTestPracticeTests : XCTestCase

@end

@implementation BlockGitUnitTestPracticeTests



- (void)testSortingPersonDataUsingComparatorBlock {
    
    NSComparator mycmp = ^(id leftObject, id rightObject){
        
        NSParameterAssert([leftObject isKindOfClass:[PersonData class]]);
        NSParameterAssert([rightObject isKindOfClass:[PersonData class]]);
        
        PersonData* left = (PersonData*)leftObject;
        PersonData* right = (PersonData*)rightObject;
        NSComparisonResult result = (NSComparisonResult)NSOrderedSame;

        // descending order is an array arranged from the largest to smallest
        if ( [left.lastname compare:right.lastname] == NSOrderedDescending){
            result =  (NSComparisonResult)NSOrderedDescending;
        }
        
        // ascending order is an array arranged from the smallest to the largest
        if ( [left.lastname compare:right.lastname] == NSOrderedAscending) {
            result =  (NSComparisonResult)NSOrderedAscending;
        }
        
        
        if ( [left.firstname compare:right.firstname] == NSOrderedDescending){
            result = (NSComparisonResult)NSOrderedDescending;
        }
        
        if ( [left.firstname compare:right.firstname] == NSOrderedAscending){
            result =  (NSComparisonResult)NSOrderedAscending;
        }
        
        return result;
    };

    NSArray* persons = @[
                         [[PersonData alloc] initWithFirstName:@"Shirley" lastName:@"Mohammed"],
                         [[PersonData alloc] initWithFirstName:@"Morgan" lastName:@"Freeman"]
                        ];
    
    NSArray* result = [persons sortedArrayUsingComparator:mycmp];
    NSArray* expected = @[
                          [[PersonData alloc] initWithFirstName:@"Morgan" lastName:@"Freeman"],
                          [[PersonData alloc] initWithFirstName:@"Shirley" lastName:@"Mohammed"]
                          ];
    
    XCTAssertEqualObjects(expected, result,"Expected person array ordering to be different");
    
}

-(void)testStringOrderingUsingBlock{
    
    NSComparator stringCmp = ^(id leftObj, id rightObj){
        
        NSString* left = (NSString*)leftObj;
        NSString* right = (NSString*)rightObj;
        NSComparisonResult result = (NSComparisonResult)NSOrderedSame;
        
        // descending order is an array arranged from the largest to smallest
        if ( [left compare:right] == NSOrderedDescending ){
            result =  (NSComparisonResult)NSOrderedDescending;
        }
        
        // ascending order is an array arranged from the smallest to the largest
        if ( [left compare:right] == NSOrderedAscending ){
            result =  (NSComparisonResult)NSOrderedAscending;
        }
        
        return result;
    
    };
    
    NSArray* strings = @[@"A", @"X", @"C", @"E"];
    NSArray* result = [strings sortedArrayUsingComparator:stringCmp];
    NSArray* expected = @[@"A", @"C", @"E", @"X"];
    
    XCTAssertEqualObjects(expected, result, "string arrays does not match");
}

typedef id(^AlphabatorBlock)(id anObject);

-(void)testPredicateUsingBlock;
{
    //Create a specific algorithm and implement it as a block
    AlphabatorBlock blkAlgo = ^id(id anObject){
      
        id returnObject = anObject;
        
        NSIndexSet* numberSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 25)];
        
        if ( [anObject isKindOfClass:[NSNumber class]]){
            NSNumber* currentNumber  = (NSNumber*)anObject;
            
            NSUInteger numberValue = [currentNumber unsignedIntegerValue];
            if ( [numberSet containsIndex:numberValue] ){
                returnObject = @(2*numberValue);
            }
        }
        
        return returnObject;
    };
    
    NSArray* array = @[ @1, @2, @50, @"Ancil"];
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for ( id elm in array){
        [outputArray addObject:blkAlgo(elm)];
    }
    
    NSArray* result = [NSArray arrayWithArray:outputArray];
    NSArray* expected = @[ @2, @4, @50, @"Ancil"];
    
    XCTAssertEqualObjects(result, expected,@"something went wrong");
    
    
    
    
}
    


@end
