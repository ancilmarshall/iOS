//
//  ViewController.m
//  CoreDataConcurrencyDemo
//
//  Created by Tim Ekl on 2015.01.18.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ObjectsViewController.h"

#import "AppDelegate.h"
#import "EditorViewController.h"

@interface ObjectsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *objectCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusManyButton;

// these tokens are handles to the notifications, which must be removed before dealloc
@property (nonatomic, strong) id parentContextObserverToken;
@property (nonatomic, strong) id editorChildContextObserverToken;
@property (nonatomic, strong) id backgroundContextObserverToken;

@end

@implementation ObjectsViewController


/*                                 NOTE
 In this app, we have a main context, a background context and a child context.
 Work can be performed in any of these contexts and in fact, different work is
 done in background and the child. The child adds one object and interacts with
 the UI and needs to be responsive (so on main queue), and the background does
 time instensive work adding new objects to its context. Both of these contexts
 saves their data and when this happens the parent merges their content, which
 can happen at different times ( asynchronously ).
 */

#pragma mark - UIViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateObjectCountLabel];
    
    //here, we update the GUI when the main context saves
    self.parentContextObserverToken =
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:[[AppDelegate delegate] rootManagedObjectContext]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self updateObjectCountLabel];
                                                  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([[segue identifier] isEqualToString:@"showEditor"]) {
        NSManagedObjectContext *parentContext = [[AppDelegate delegate] rootManagedObjectContext];
        NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        childContext.parentContext = parentContext;
        
        self.editorChildContextObserverToken =
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                          object:childContext
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          [parentContext mergeChangesFromContextDidSaveNotification:note];
                                                          
                                                          NSError *error = nil;
                                                          if (![parentContext save:&error]) {
                                                              NSLog(@"Failed to propagate changes from child context: %@", error);
                                                          }
                                                      }];
        
        EditorViewController *editor = (EditorViewController *)[[segue destinationViewController] topViewController];
        editor.context = childContext;
    }
}

#pragma mark - Actions

- (IBAction)cancelEditor:(UIStoryboardSegue *)segue;
{
    self.editorChildContextObserverToken = nil;
}

- (IBAction)saveEditor:(UIStoryboardSegue *)segue;
{
    EditorViewController *editor = (EditorViewController *)[segue sourceViewController];
    
    
    // this is and unwind segue and the save to the context is performed here. The
    // save is noticed due to the notification center and the appropriate block is run
    NSError *error = nil;
    if (![editor.context save:&error]) {
        NSLog(@"Failed to save child context: %@", error);
    }
    
    [self cancelEditor:segue];
}

- (IBAction)plusMany:(id)sender {
    NSManagedObjectContext *mainContext = [[AppDelegate delegate] rootManagedObjectContext];
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = mainContext;
    
    self.backgroundContextObserverToken =
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:backgroundContext
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSAssert([NSThread isMainThread], @"Need to be on the main thread to merge into the main MOC (and perform UI changes)");
                                                      
                                                      [mainContext performBlock:^{
                                                          [mainContext mergeChangesFromContextDidSaveNotification:note];
                                                          
                                                          //save to the persistent store here
                                                          NSError *error = nil;
                                                          if (![mainContext save:&error]) {
                                                              NSLog(@"Failed to merge background changes: %@", error);
                                                              return;
                                                          }
                                                      }];
                                                      
                                                      self.plusManyButton.enabled = YES;
                                                      self.backgroundContextObserverToken = nil;
                                                  }];
    
    self.plusManyButton.enabled = NO;
    
    //Making changes to background context by instantiating new objects to it, and simulating here that this
    // is a time intensive process (by using the sleep process)
    [backgroundContext performBlock:^{
        for (NSUInteger i = 0; i < 1000; i++) {
            NSManagedObject *stringEntity = [NSEntityDescription insertNewObjectForEntityForName:@"StringEntity" inManagedObjectContext:backgroundContext];
            [stringEntity setValue:[@(i) stringValue] forKey:@"string"];
            
            if (i % 100 == 0) {
                sleep(1);
            }
        }
        
        //when the save happens here, it triggers the save notification, which the notification center
        //then performs the block passed into it (which happens to perform work on the main context)
        NSError *error = nil;
        if (![backgroundContext save:&error]) {
            NSLog(@"Failed to save 1000 objects: %@", error);
        }
    }];
}

#pragma mark - Private

- (void)updateObjectCountLabel;
{
    NSAssert([NSThread isMainThread], @"Must be on the main thread to update UI");
    NSAssert([self isViewLoaded], @"Can't update object count label before view loading");
    
    NSManagedObjectContext *moc = [[AppDelegate delegate] rootManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StringEntity"];
    
    //this fetch is from the rootManagedObject on the main queue and gets data from persistent store or
    //from the existing or modified objects already in the context
    NSError *error = nil;
    NSArray *stringEntities = [moc executeFetchRequest:fetchRequest error:&error];
    if (stringEntities == nil) {
        self.objectCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Error fetching strings: %@", nil), [error localizedDescription]];
        return;
    }
    
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    
    self.objectCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ object(s)", nil), [formatter stringFromNumber:@([stringEntities count])]];
}

@end
