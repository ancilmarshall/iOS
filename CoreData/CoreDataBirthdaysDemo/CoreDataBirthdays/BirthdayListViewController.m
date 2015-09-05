//
//  ViewController.m
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "BirthdayListViewController_Subclass.h"

#import "AppDelegate.h"
#import "Person.h"
#import "PersonGenerator.h"

@interface BirthdayListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BirthdayListViewController

#pragma mark - Subclass responsibility

- (NSString *)entityName;
{
    NSAssert(false, @"Subclass should provide valid entity name");
    return nil;
}

- (NSPredicate *)fetchPredicate;
{
    NSAssert(false, @"Subclass should provide valid fetch predicate");
    return nil;
}

#pragma mark - UIViewController subclass

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[AppDelegate delegate] rootManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES] ];
    fetchRequest.predicate = [self fetchPredicate];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Couldn't perform initial fetch; you're unlikely to see data. %@", error);
        return;
    }
    
    self.fetchedResultsController.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"birthdayCell" forIndexPath:indexPath];
    NSManagedObject *birthdayObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [birthdayObject valueForKey:NSStringFromSelector(@selector(name))];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[birthdayObject valueForKey:NSStringFromSelector(@selector(birthday))]];
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    NSLog(@"Child context is about to be saved");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
{
    NSAssert(false, @"nope");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView endUpdates];
}

@end
