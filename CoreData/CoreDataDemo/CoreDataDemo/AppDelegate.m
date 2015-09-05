//
//  AppDelegate.m
//  CoreDataDemo
//
//  Created by Tim Ekl on 2015.01.13.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreData/CoreData.h>

@interface AppDelegate ()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation AppDelegate

+ (instancetype)sharedDelegate;
{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    NSAssert([delegate isKindOfClass:[AppDelegate class]], @"Expected to use our app delegate class");
    return (AppDelegate *)delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (NSManagedObjectContext *)managedObjectContext;
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:[self SQLiteStoreURL]
                                                       options:nil
                                                         error:&error];
    if (store == nil) {
        NSLog(@"Failed to set up in-memory store: %@", error);
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = psc;
    return _managedObjectContext;
}

- (NSURL *)SQLiteStoreURL;
{
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSAssert([URLs count] > 0, @"Expected to find a document URL");
    NSURL *documentDirectory = URLs[0];
    return [[documentDirectory URLByAppendingPathComponent:@"tasks"] URLByAppendingPathExtension:@"sqlite"];
}

@end
