//
//  HW2TodoList.m
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW2TodoList.h"

@interface HW2TodoList()
@property (nonatomic,strong) NSMutableArray* list;
@end

@implementation HW2TodoList

#pragma mark - Initialization
//lazy instantiation
-(NSMutableArray*)list
{
    if (!_list) { _list = [[NSMutableArray alloc] init]; }
    return _list;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.allowDuplicates = YES;
    }
    return self;
}

//convenience constructor. Creates new instance of HW2TodoList and returns to
//caller. Delegate must be passed in since must be set before adding items
+(instancetype)groceryListWithDelegate:(id<HW2TodoListDelegate>)delegate
{
    HW2TodoList* todolist = [[HW2TodoList alloc] init];
    todolist.delegate = delegate;
    [todolist addItemWithTitle:@"Apples"];
    [todolist addItemWithTitle:@"Chicken"];
    [todolist addItemWithTitle:@"Salmon"];
    [todolist addItemWithTitle:@"Rice"];
    [todolist addItemWithTitle:@"Green Beans"];
    return todolist;
}

//convenience constructor. Creates new instance of HW2TodoList and returns to
//caller. Delegate must be passed in since must be set before adding items
+(instancetype)suitcaseListWithDelegate:(id<HW2TodoListDelegate>)delegate
{
    HW2TodoList* todolist = [[HW2TodoList alloc] init];
    todolist.delegate = delegate;
    [todolist addItemWithTitle:@"Toothbrush"];
    [todolist addItemWithTitle:@"Chargers"];
    [todolist addItemWithTitle:@"Pillow"];
    [todolist addItemWithTitle:@"iPad"];
    [todolist addItemWithTitle:@"Passport"];
    return todolist;
}


#pragma mark - Adding items
//adds an item if it is possible
-(void)addItem:(HW2TodoItem *)item
{
    if ([self canAddItem:item])
    {
        [self.list addObject:item];
        
        if (self.delegate)
            [self.delegate todoList:self didAddItem:item];
        else {
            NSException *exception = [NSException
              exceptionWithName:@"UnassignedDelegate"
                         reason:@"HW2TodoList delegate is not assigned"
                       userInfo:nil];
            @throw exception;
        }
    }
}

//helper function to check if dupblicates are allowed
-(BOOL)canAddItem:(HW2TodoItem *)item
{
    if (self.allowDuplicates)
        return YES;
    else
    {
        if ([self.list containsObject:item])
            return NO;
        else
            return YES;
    }
}

//client calls this function since it is simpler to call with title string
-(void)addItemWithTitle:(NSString *)title
{
    HW2TodoItem* item = [HW2TodoItem todoItemWithTitle:title];
    [self addItem:item];
}


#pragma mark - Removing items
//Note: removes all items that match (not just one match)
-(void)removeItem:(HW2TodoItem*)item
{
    if ([self.list containsObject:item])
    {
        [self.list removeObject:item];
        
        if (self.delegate)
            [self.delegate todoList:self didDeleteItem:item];
        else {
            NSException *exception = [NSException
                exceptionWithName:@"UnassignedDelegate"
                           reason:@"HW2TodoList delegate is not assigned"
                         userInfo:nil];
            @throw exception;
        }
    }
}

//Note: removes all items that match (not just one match)
-(void)removeItemWithTitle:(NSString *)title
{
    HW2TodoItem* item = [HW2TodoItem todoItemWithTitle:title];
    [self removeItem:item];
}


#pragma mark - Helper functions
-(NSUInteger)itemCount
{
    return [self.list count];
}

//client uses this funciton to check if item exists in the list
-(BOOL)hasItemWithTitle:(NSString *)title
{
    HW2TodoItem* item = [HW2TodoItem todoItemWithTitle:title];
    if ([self.list containsObject:item])
        return YES;
    else
        return NO;
}

//Note: also used to update view, which is a nice use of the available method
-(NSString*)description
{
    NSMutableArray* titles = [[NSMutableArray alloc] init];
    for (HW2TodoItem* item in self.list) {
        [titles addObject:item.getTitle];
    }

    NSString* str = [titles componentsJoinedByString:@"\n\t"];
    NSString* descrStr = @"ToDoList:\n\t";
    
    if (str)
        descrStr = [descrStr stringByAppendingString:str];
    
    return descrStr;
}

@end



