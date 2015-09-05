//
//  ViewController.m
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "ColorViewController.h"

#import "AppDelegate.h"
#import "Color+Extensions.h"
#import "ColorManagedObjectContext.h"

@interface CollectionViewChange : NSObject
@property (nonatomic, assign) NSFetchedResultsChangeType changeType;
@property (nonatomic, copy) NSIndexPath *fromIndexPath;
@property (nonatomic, copy) NSIndexPath *toIndexPath;
@end

@implementation CollectionViewChange
@end

#pragma mark -

@interface ColorViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *queuedCollectionViewChanges;

@end

@implementation ColorViewController

- (IBAction)addColor:(id)sender {
    ColorManagedObjectContext *moc = [[AppDelegate delegate] managedObjectContext];
    [moc insertCountOfRandomColors:5];
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"Failed to insert color: %@", error);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Color class])];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(alpha)) ascending:YES],
                                      [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(blue)) ascending:YES],
                                      [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(green)) ascending:YES],
                                      [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(red)) ascending:YES] ];
    
    NSManagedObjectContext *moc = [[AppDelegate delegate] managedObjectContext];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Failed to perform initial fetch: %@", error);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    Color *color = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [color UIColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Color *color = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ColorManagedObjectContext *moc = [[AppDelegate delegate] managedObjectContext];
    [moc deleteObject:color];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"Failed to delete color: %@", error);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    self.queuedCollectionViewChanges = [NSMutableArray array];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    CollectionViewChange *change = [[CollectionViewChange alloc] init];
    change.changeType = type;
    change.fromIndexPath = indexPath;
    change.toIndexPath = newIndexPath;
    [self.queuedCollectionViewChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    NSArray *changes = [self.queuedCollectionViewChanges copy];
    self.queuedCollectionViewChanges = nil;
    
    [self.collectionView performBatchUpdates:^{
        [changes enumerateObjectsUsingBlock:^(CollectionViewChange *change, NSUInteger idx, BOOL *stop) {
            
            switch (change.changeType) {
                case NSFetchedResultsChangeInsert:
                    [self.collectionView insertItemsAtIndexPaths:@[ change.toIndexPath ]];
                    break;
                    
                case NSFetchedResultsChangeDelete:
                    [self.collectionView deleteItemsAtIndexPaths:@[ change.fromIndexPath ]];
                    break;
                    
                default:
                    NSLog(@"ignoring change");
                    break;
            }
            
        }];
    } completion:nil];
}

@end
