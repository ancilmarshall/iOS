//
//  PersonListViewController.m
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "BirthdayListViewController_Subclass.h"
#import "PersonListViewController.h"

#import "Person.h"
#import "PersonGenerator.h"
#import "PetListViewController.h"

@interface PersonListViewController ()

@property (nonatomic, strong) PersonGenerator *personGenerator;

@end

@implementation PersonListViewController

- (IBAction)startGenerating:(id)sender {
    NSManagedObjectContext *generatorContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    generatorContext.parentContext = self.managedObjectContext;
    self.personGenerator = [[PersonGenerator alloc] initWithManagedObjectContext:generatorContext initialCount:[self.tableView numberOfRowsInSection:0]]; // starts generating immediately
}

- (IBAction)stopGenerating:(id)sender {
    self.personGenerator = nil;
}

#pragma mark - BirthdayListViewController subclass

- (NSString *)entityName;
{
    return NSStringFromClass([Person class]);
}

- (NSPredicate *)fetchPredicate;
{
    return nil;
}

#pragma mark - UIViewController subclass

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([segue.destinationViewController isKindOfClass:[PetListViewController class]]) {
        PetListViewController *petListController = (PetListViewController *)[segue destinationViewController];
        
        NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        childContext.parentContext = self.managedObjectContext;
        petListController.managedObjectContext = childContext;
        
        petListController.owner = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

@end
