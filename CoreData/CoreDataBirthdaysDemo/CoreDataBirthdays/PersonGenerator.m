//
//  PersonGenerator.m
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "PersonGenerator.h"
#import "Person.h"
#import "Pet.h"

@interface PersonGenerator ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (atomic, assign) NSUInteger generatedCount;

@end

@implementation PersonGenerator

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    return [self initWithManagedObjectContext:managedObjectContext initialCount:0];
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext initialCount:(NSUInteger)generatedCount;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    NSParameterAssert(managedObjectContext != nil);
    _managedObjectContext = managedObjectContext;
    _generatedCount = generatedCount;
    
    [self enqueueNewPerson];
    
    return self;
}

- (void)enqueueNewPerson;
{
    uint32_t numberOfSeconds = arc4random_uniform(3) + 1;
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(numberOfSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf generatePerson];
        [strongSelf enqueueNewPerson];
    });
}

- (void)generatePerson;
{
    self.generatedCount ++;
    
    [self.managedObjectContext performBlock:^{
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class])
                                                       inManagedObjectContext:self.managedObjectContext];
        person.name = [NSString stringWithFormat:@"Generated Person %tu", self.generatedCount];
        person.birthday = [NSDate date];
        
        NSUInteger petCount = arc4random_uniform(3)+1;
        for (NSUInteger i = 0; i < petCount; i++) {
            Pet *pet = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Pet class])
                                                     inManagedObjectContext:self.managedObjectContext];
            pet.name = [[self class] randomPetName];
            pet.birthday = [NSDate date];
            pet.owner = person; // CoreData automatically adds this pet to the owners collection of pets.. good advantage of CoreData here!
        }
        
        //once person saves in its context, its parent is made aware. It just so happens that the parent has a fetchedResultsController which can detect these changes
        NSLog(@"About to save in the child context");
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Failed to generate person %tu: %@", self.generatedCount, error);
        } else {
            NSLog(@"Generated person %tu", self.generatedCount);
        }
    }];
}

- (void)dealloc;
{
    NSLog(@"goodbye PersonGenerator");
}

+ (NSArray *)petNames;
{
    static NSArray *_names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _names = @[ @"Fido", @"Spot", @"Clifford", @"Paddington", @"Scout", @"Champ", @"Scooter", @"Dude" ];
    });
    return _names;
}

+ (NSString *)randomPetName;
{
    NSArray *names = [self petNames];
    NSUInteger index = arc4random_uniform((uint32_t)[names count]);
    return names[index];
}

@end
