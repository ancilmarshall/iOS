//
//  HW2TodoItem.m
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW2TodoItem.h"

@interface HW2TodoItem()
@property (nonatomic,strong,readwrite) NSString* title;
@end

@implementation HW2TodoItem

//convenience constructor
+(instancetype)todoItemWithTitle:(NSString*)title
{
    HW2TodoItem* item = [[HW2TodoItem alloc] init];
    item.title = title;
    return item;
}

//overload the description method
-(NSString*)description
{
    return [NSString stringWithFormat:@"Item: %@",self.title];
}

//overload isEqual which is needed for algorithms (finding, removing, etc)
-(BOOL)isEqual:(HW2TodoItem*)item
{
    if ( [self.title isEqualToString:item.getTitle] )
        return YES;
    else
        return NO;
}


@end
