//
//  HW2TodoItem.h
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HW2TodoItem : NSObject

@property (nonatomic,strong,readonly,getter = getTitle) NSString* title;
+(instancetype)todoItemWithTitle:(NSString*)title;

@end
