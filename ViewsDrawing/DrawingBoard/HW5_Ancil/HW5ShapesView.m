//
//  HW5ShapesView.m
//  HW5_Ancil
//
//  Created by Ancil on 8/10/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW5ShapesView.h"

@implementation HW5ShapesView

#define GAP_IN_POINTS 20

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSSize viewSize = self.bounds.size;
    
    [[NSColor whiteColor] set];
    NSRect backgroundRect = NSMakeRect(0+GAP_IN_POINTS,0+GAP_IN_POINTS,
                                       viewSize.width-2*GAP_IN_POINTS,
                                       viewSize.height-2*GAP_IN_POINTS);
    NSBezierPath* backgroundPath = [NSBezierPath bezierPathWithRect:backgroundRect];
    [backgroundPath addClip];
    NSRectFill(backgroundRect);
    
    [[NSColor greenColor] set];
    [NSBezierPath strokeRect:backgroundRect];
    
    [self drawSquare:backgroundRect   section:0];
    [self drawTriangle:backgroundRect section:1];
    [self drawCircle:backgroundRect   section:2];

}

//Create a box that is a third of the width of the original, offset by a section number
-(NSRect)getBoundingBox:(NSRect)frame section:(NSUInteger)section
{
    return NSMakeRect( (frame.origin.x + section*frame.size.width/3) + GAP_IN_POINTS,
                        frame.origin.y+GAP_IN_POINTS,
                        frame.size.width/3-2*GAP_IN_POINTS,
                        frame.size.width/3-2*GAP_IN_POINTS );
}

-(void)drawTriangle:(NSRect)frame section:(NSUInteger)section
{
    
    NSRect box = [self getBoundingBox:frame section:section];
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path moveToPoint: box.origin];
    [path relativeLineToPoint:NSMakePoint(box.size.width/2, box.size.height)];
    [path relativeLineToPoint:NSMakePoint(box.size.width/2, -box.size.height)];
    [path closePath];

    [path fill];
    
}


-(void)drawSquare:(NSRect)frame section:(NSUInteger)section
{
    NSRect box = [self getBoundingBox:frame section:section];
    NSRectFill(box);
}

-(void)drawCircle:(NSRect)frame section:(NSUInteger)section
{
    NSRect box = [self getBoundingBox:frame section:section];
    NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:box];
    [path fill];
}
@end
