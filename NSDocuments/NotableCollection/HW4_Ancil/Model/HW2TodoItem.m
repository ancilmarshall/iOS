//
//  HW2TodoItem.m
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW2TodoItem.h"

@interface HW2TodoItem()

@end

@implementation HW2TodoItem

//convenience constructor
+(instancetype)todoItemWithTitle:(NSString*)title
{
    HW2TodoItem* item = [[HW2TodoItem alloc] init];
    item.title = title;
    item.detail = @"";
    item.image = nil;
    return item;
}

+(instancetype)todoItemWithTitle:(NSString*)title detail:(NSString*)details;
{
    HW2TodoItem* item = [[HW2TodoItem alloc] init];
    item.title = title;
    item.detail = details;
    item.image = nil;
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
    if ( [self.title isEqualToString:item.title] )
        return YES;
    else
        return NO;
}

#pragma mark - Required NSCoding delegate methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"titleKey"];
    [aCoder encodeObject:self.detail forKey:@"detailKey"];
    [aCoder encodeObject:self.image forKey:@"imageKey"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"titleKey"];
        _detail = [aDecoder decodeObjectForKey:@"detailKey"];
        _image = [aDecoder decodeObjectForKey:@"imageKey"];
    }
    return self;
}

@end
