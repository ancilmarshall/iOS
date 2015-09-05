//
//  Person.h
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pet;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSSet *pets;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addPetsObject:(Pet *)value;
- (void)removePetsObject:(Pet *)value;
- (void)addPets:(NSSet *)values;
- (void)removePets:(NSSet *)values;

@end
