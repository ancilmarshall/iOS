//
//  AppDelegate.m
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"

#import "ColorManagedObjectContext.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)delegate;
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.managedObjectContext = [ColorManagedObjectContext contextForStoreAtURL:nil];
    [self.managedObjectContext insertCountOfRandomColors:50];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to seed random color data: %@", error);
    }
    
    return YES;
}

@end
