//
//  ViewController.m
//  CoreDataDemo
//
//  Created by Tim Ekl on 2015.01.13.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "TaskListTableViewController.h"

#import "AppDelegate.h"
#import "TaskList.h"

#import <CoreData/CoreData.h>

@interface TaskListTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TaskListTableViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    self.managedObjectContext = [[AppDelegate sharedDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TaskList"];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
                                      [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES] ];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error performing initial fetch! Not sure what to do... %@", error);
    }
    
    self.title = NSLocalizedString(@"Task Lists", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskList:)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionObject = sections[section];
    return [sectionObject numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionObject = sections[indexPath.section];
    TaskList *taskList = [sectionObject objects][indexPath.row];
    
    cell.textLabel.text = taskList.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSParameterAssert(editingStyle == UITableViewCellEditingStyleDelete);
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionObject = sections[indexPath.section];
    TaskList *taskList = [sectionObject objects][indexPath.row];
    
    [self.managedObjectContext deleteObject:taskList];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save deletion of object: %@", error);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
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
            
        default:
            NSLog(@"Unimplemented change type! Doing nothing – the table will likely break...");
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView endUpdates];
}

#pragma mark - Private

- (IBAction)addTaskList:(id)sender;
{
    TaskList *taskList = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TaskList class])
                                                       inManagedObjectContext:self.managedObjectContext];
    taskList.title = NSLocalizedString(@"New Task List", nil);
    taskList.dateCreated = [NSDate date];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving new task list in MOC: %@", error);
    }
}

@end
