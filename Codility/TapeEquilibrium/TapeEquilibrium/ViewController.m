//
//  ViewController.m
//  TapeEquilibrium
//
//  Created by Ancil on 9/14/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "ViewController.h"

@interface Square : NSObject

@end

@implementation Square

-(instancetype)init;
{
    self = [super init];
    NSLog(@"Init");
    return self;
}

-(void)doSomething;
{
    NSLog(@"DoSomething");
}

@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Square* sq = nil;
    [sq doSomething];
    
    NSArray* arr = [NSArray arrayWithObjects:nil];
    
    id myobjet;
    
    
    //Square* sq = [[Square alloc] init];

}


@end
