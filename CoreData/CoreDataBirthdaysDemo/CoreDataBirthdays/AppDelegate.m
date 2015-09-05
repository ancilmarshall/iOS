//
//  AppDelegate.m
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *rootManagedObjectContext;

@end

@implementation AppDelegate

+ (instancetype)delegate;
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:[[self class] defaultStoreURL]
                                 options:nil
                                   error:&error]) {
        NSLog(@"Failed to get a root MOC; this will cause trouble... %@", error);
        return YES;
    }
    
    self.rootManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.rootManagedObjectContext.persistentStoreCoordinator = psc;
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application;
{
    [self.rootManagedObjectContext performBlock:^{
        NSError *error = nil;
        if (![self.rootManagedObjectContext save:&error]) {
            NSLog(@"Failed to save on entering background: %@", error);
        }
    }];
}

+ (NSURL *)defaultStoreURL;
{
    NSError *error = nil;
    NSURL *documentURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                inDomain:NSUserDomainMask
                                                       appropriateForURL:nil
                                                                  create:NO
                                                                   error:&error];
    if (documentURL == nil) {
        NSLog(@"Gonna be hard to save a store without a Documents directory... %@", error);
        return nil;
    }
    
    return [[documentURL URLByAppendingPathComponent:@"BirthdayData"] URLByAppendingPathExtension:@"sqlite"];
}

@end
