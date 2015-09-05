//
//  BirthdayListViewController_Subclass.h
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "BirthdayListViewController.h"

#import <CoreData/CoreData.h>

@interface BirthdayListViewController ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
- (NSFetchedResultsController *)fetchedResultsController;

// Subclass responsibility – you must override these methods
- (NSString *)entityName;
- (NSPredicate *)fetchPredicate;

@end
