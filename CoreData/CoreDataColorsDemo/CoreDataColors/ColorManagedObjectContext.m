//
//  ColorManagedObjectContext.m
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "ColorManagedObjectContext.h"

#import "Color.h"

@implementation ColorManagedObjectContext

+ (instancetype)contextForStoreAtURL:(NSURL *)storeURL;
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSError *error = nil;
    NSString *storeType = (storeURL == nil) ? NSInMemoryStoreType : NSSQLiteStoreType;
    if (![psc addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Couldn't add store (type=%@): %@", storeType, error);
        return nil;
    }
    
    ColorManagedObjectContext *moc = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;
    return moc;
}

- (void)insertCountOfRandomColors:(NSUInteger)count;
{
    for (NSUInteger i = 0; i < count; i++) {
        
        Color *color = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Color class])
                                                     inManagedObjectContext:self];
        
        color.red = (float)arc4random_uniform(256) / 255.0;
        color.green = (float)arc4random_uniform(256) / 255.0;
        color.blue = (float)arc4random_uniform(256) / 255.0;
        color.alpha = 1.0;
        
    }
}

@end
