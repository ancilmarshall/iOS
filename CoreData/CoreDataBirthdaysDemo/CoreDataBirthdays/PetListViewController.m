//
//  PetListViewController.m
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "BirthdayListViewController_Subclass.h"
#import "PetListViewController.h"

#import "Person.h"
#import "Pet.h"

@interface PetListViewController ()

@end

@implementation PetListViewController

- (void)setOwner:(Person *)owner;
{
    _owner = (Person *)[self.managedObjectContext objectWithID:owner.objectID];
}

#pragma mark - BirthdayListViewController subclass

- (NSString *)entityName;
{
    return NSStringFromClass([Pet class]);
}

- (NSPredicate *)fetchPredicate;
{
    NSAssert(self.owner != nil, @"Only want pets for this owner");
    //search for all pets in the context such that the value of the key 'owner' has value self.owner
    return [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(owner)), self.owner];
}

@end
