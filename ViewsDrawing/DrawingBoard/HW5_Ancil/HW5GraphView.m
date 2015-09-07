//
//  HW5GraphView.m
//  HW5_Ancil
//
//  Created by Ancil on 8/10/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <stdlib.h>
#import "HW5GraphView.h"

#define NUMBER_OF_POINTS 10
#define GAP_IN_POINTS 20
#define BOTTOM_GAP_IN_POINTS 60

@interface HW5GraphView()
@property (nonatomic,strong) NSMutableArray* randomArray; //of NSNumbers
@end;


@implementation HW5GraphView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.randomArray = [[NSMutableArray alloc] init];
        [self generateNewData];
    
    }
    return self;
}

-(void)generateNewData
{
    [self.randomArray removeAllObjects];
    for (int i=0; i<NUMBER_OF_POINTS+1; i++)
    {
        [self.randomArray addObject:@((arc4random_uniform(255)/255.0))];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSSize viewSize = self.bounds.size;
    
    [[NSColor whiteColor] set];
    NSRect box = NSMakeRect(0+GAP_IN_POINTS,0+BOTTOM_GAP_IN_POINTS,
                                       viewSize.width-2*GAP_IN_POINTS,
                                       viewSize.height-(BOTTOM_GAP_IN_POINTS + GAP_IN_POINTS));
    
    NSBezierPath* backgroundPath = [NSBezierPath bezierPathWithRect:box];
    [backgroundPath addClip];
    NSRectFill(box);
    
    [[NSColor greenColor] set];
    [NSBezierPath strokeRect:box];
    
    NSPoint points[NUMBER_OF_POINTS+1];
    for (int i=0; i<NUMBER_OF_POINTS+1;i++)
    {
        points[i] = NSMakePoint( box.origin.x + (float)i/NUMBER_OF_POINTS*box.size.width,
                                box.origin.y + [[self.randomArray objectAtIndex:i] floatValue] * box.size.height);
    }
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path moveToPoint:box.origin];
    [path appendBezierPathWithPoints:points count:NUMBER_OF_POINTS+1];
    [path lineToPoint:NSMakePoint(box.origin.x + box.size.width,box.origin.y)];
    [path closePath];
    [path fill];
    
    [[NSColor redColor] set];
    [path stroke];
}

@end
