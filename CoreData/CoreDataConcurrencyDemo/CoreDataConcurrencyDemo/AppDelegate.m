//
//  AppDelegate.m
//  CoreDataConcurrencyDemo
//
//  Created by Tim Ekl on 2015.01.18.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *rootManagedObjectContext;

@end

@implementation AppDelegate

+ (instancetype)delegate;
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSURL *momURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSError *error = nil;
    if (![psc addPersistentStoreWithType:NSInMemoryStoreType
                           configuration:nil
                                     URL:nil
                                 options:nil
                                   error:&error]) {
        NSLog(@"setting up persistent store failed: %@", error);
        return YES;
    }
    
    //setup root managed object with the main queue concurrency type
    self.rootManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.rootManagedObjectContext.persistentStoreCoordinator = psc;
    
    return YES;
}

@end
