//
//  ColorManagedObjectContext.h
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ColorManagedObjectContext : NSManagedObjectContext

+ (instancetype)contextForStoreAtURL:(NSURL *)URL;

- (void)insertCountOfRandomColors:(NSUInteger)count;

@end
