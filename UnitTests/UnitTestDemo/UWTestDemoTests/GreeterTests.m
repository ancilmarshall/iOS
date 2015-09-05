//
//  UWTestDemoTests.m
//  UWTestDemoTests
//
//  Created by Tim Ekl on 2015.01.07.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Greeter.h"

@interface GreeterTests : XCTestCase

@property (nonatomic, strong) Greeter *greeter;

@end

@implementation GreeterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.greeter = [[Greeter alloc] init];
}

- (void)tearDown {
    self.greeter = nil;
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTimGreeting {
    NSString *greeting = [self.greeter helloMessageForName:@"Tim"];
    XCTAssertEqualObjects(greeting, @"Hello, Tim!", @"Expected both Hello prefix and ! suffix on name");
}

- (void)testNobodyGreeting {
    NSString *greeting = [self.greeter helloMessageForName:nil];
    XCTAssertEqualObjects(greeting, @"Hello, World!", @"Expected generic World greeting for no name");
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
