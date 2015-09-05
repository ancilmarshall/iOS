//
//  NSArray+FPBlockExtensions.h
//  FPBlockDemo
//
//  Created by Tim Ekl on 2015.01.10.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^ApplierBlock)(id anObject);
typedef BOOL(^PredicateBlock)(id anObject);




@interface NSArray (FPBlockExtensions)

- (NSArray *)arrayByPerformingBlock:(ApplierBlock)block;
- (NSArray *)objectsPassingTest:(PredicateBlock)predicate;

@end
