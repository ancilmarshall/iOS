//
//  HW2TodoList.h
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HW2TodoItem.h"

@class HW2TodoList;

@protocol HW2TodoListDelegate

-(void)todoList:(HW2TodoList*)todoList didAddItem:(HW2TodoItem*)item;
-(void)todoList:(HW2TodoList*)todoList didDeleteItem:(HW2TodoItem*)item;
@end

@interface HW2TodoList : NSObject

@property (nonatomic) BOOL allowDuplicates;
@property (nonatomic,weak) id<HW2TodoListDelegate> delegate;

+(instancetype)groceryListWithDelegate:(id<HW2TodoListDelegate>)delegate;
+(instancetype)suitcaseListWithDelegate:(id<HW2TodoListDelegate>)delegate;

-(void)addItem:(HW2TodoItem*)item;              // insert item if OK
-(void)addItemWithTitle:(NSString*)title;       // create and insert item if OK
-(BOOL)hasItemWithTitle:(NSString*)title;       // check if any item contained already has same title
-(void)removeItemWithTitle:(NSString*)title;    //remove item from list

-(NSUInteger)itemCount;     // number of items contained in list

@end
