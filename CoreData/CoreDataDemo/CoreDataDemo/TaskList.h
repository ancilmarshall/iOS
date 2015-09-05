//
//  TaskList.h
//  CoreDataDemo
//
//  Created by Tim Ekl on 2015.01.13.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskList : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSOrderedSet *tasks;
@end

@interface TaskList (CoreDataGeneratedAccessors)

- (void)insertObject:(Task *)value inTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTasksAtIndex:(NSUInteger)idx;
- (void)insertTasks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTasksAtIndex:(NSUInteger)idx withObject:(Task *)value;
- (void)replaceTasksAtIndexes:(NSIndexSet *)indexes withTasks:(NSArray *)values;
- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSOrderedSet *)values;
- (void)removeTasks:(NSOrderedSet *)values;
@end
