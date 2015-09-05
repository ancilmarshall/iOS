//
//  PersonGenerator.h
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersonGenerator : NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext initialCount:(NSUInteger)generatedCount NS_DESIGNATED_INITIALIZER;

@end
