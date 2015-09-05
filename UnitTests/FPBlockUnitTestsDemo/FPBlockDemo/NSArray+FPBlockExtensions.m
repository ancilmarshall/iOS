//
//  NSArray+FPBlockExtensions.m
//  FPBlockDemo
//
//  Created by Tim Ekl on 2015.01.10.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "NSArray+FPBlockExtensions.h"

@implementation NSArray (FPBlockExtensions)

- (NSArray *)arrayByPerformingBlock:(ApplierBlock)block;
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id anObject in self) {
        [result addObject:block(anObject)];
    }
    return [NSArray arrayWithArray:result];
}

- (NSArray *)objectsPassingTest:(PredicateBlock)predicate;
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id anObject in self) {
        if (predicate(anObject)) {
            [result addObject:anObject];
        }
    }
    return [NSArray arrayWithArray:result];
}



@end
