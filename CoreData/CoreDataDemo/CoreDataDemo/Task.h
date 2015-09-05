//
//  Task.h
//  CoreDataDemo
//
//  Created by Tim Ekl on 2015.01.13.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSManagedObject *taskList;

@end
