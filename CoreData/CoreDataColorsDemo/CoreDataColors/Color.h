//
//  Color.h
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Color : NSManagedObject

@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;
@property (nonatomic) float alpha;

@end
