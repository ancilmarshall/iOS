//
//  HW5ArtView.m
//  HW5_Ancil
//
//  Created by Ancil on 8/11/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

// Future: Pan Gesture should be attached to the view


#import "HW5ArtView.h"
#import "Utility.h"
#import "GameModel/Game.h"
#import "GameModel/Item.h"

@interface HW5ArtView()

@property (nonatomic,strong) NSMutableArray* draggableViews;
@property (nonatomic,strong) NSMutableArray* droppableViews;
@property (nonatomic,strong) NSMutableArray* resultsViews;
@property (nonatomic,strong) NSMutableArray* disabledViews;

@property (nonatomic) NSRect originalFrame;
@property (nonatomic,strong) NSView* viewBeingDragged;
@property (nonatomic) NSPoint prevLocation;
@property (nonatomic,strong) NSButton* gameButton;
@property (nonatomic,strong) NSButton* checkAnswersButton;
@property (nonatomic) NSUInteger numberOfQuestionsAnswered;

@property (nonatomic,strong) NSTextView* titleTextView;

//Future: move this game model to the controller and use protocols to get data
@property (nonatomic,strong) Game* game;
@property (nonatomic,strong) NSArray* gameDeck;
@end

@implementation HW5ArtView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _game = [Game new];
        
        _draggableViews = [NSMutableArray new];
        _droppableViews = [NSMutableArray new];
        _resultsViews = [NSMutableArray new];
        _disabledViews = [NSMutableArray new];
        _viewBeingDragged = nil;
        
        //add dummy item to the view.
        for (int ii = 0; ii < 4; ii++)
        {
            [_disabledViews addObject:@(0)];
        }

        _gameButton = [[NSButton alloc] initWithFrame:[self calcGameButtonViewFrame]];
        _gameButton.title = @"New Game";
        [_gameButton setTarget:self];
        [_gameButton setAction:@selector(newGame:)];
        [self addSubview:_gameButton];
        
        _titleTextView = [[NSTextView alloc] initWithFrame:[self calcTitleTextViewFrame]];
        [self addSubview:_titleTextView];
        [_titleTextView setEditable:NO];
        
        [self newGame:nil];
        
    }
    return self;
}

-(void) newGame:(NSButton*)sender
{
    [self.checkAnswersButton setEnabled:NO];
    
    for (NSTextView* view in self.resultsViews)
        [view removeFromSuperview];
    
    for (NSView* view in self.draggableViews)
        [view removeFromSuperview];
    
    for (NSView* view in self.droppableViews)
        [view removeFromSuperview];

    [self.draggableViews removeAllObjects];
    [self.droppableViews removeAllObjects];
    [self.resultsViews removeAllObjects];
    
    self.gameDeck = [self.game getNewGame];
    self.numberOfQuestionsAnswered = 0;
    

    for (int ii=0; ii< [self.gameDeck count]; ii++)
    {
        NSView* draggableView = [NSView new];
        NSView* droppableView = [NSView new];
        NSTextView* resultsLabelView = [NSTextView new];
        
        //Future: Here, ask a delegate (ex the viewController) to get data at index ii
        //example... [self.delegate itemAtIndex:ii];
        //or [self.delegate questionAtIndex:ii], [self.delegate answerAtIndex:ii];
        // and the delegate must implement these functions as a protocol... so the
        // view has to define this protocol
        Item* item = [self.gameDeck objectAtIndex:ii];
        draggableView.identifier = item.question;
        droppableView.identifier = item.answer;
        
        [self.draggableViews addObject:draggableView];
        [self.droppableViews addObject:droppableView];
        [self.resultsViews addObject:resultsLabelView];
        
    }
    
    self.droppableViews = [Utility randomizeArray:self.droppableViews
                                          ForSize:[self.droppableViews count]];
    for (int ii=0; ii< [self.gameDeck count]; ii++)
    {
        [[self.droppableViews objectAtIndex:ii] setFrame:[self calcDroppableViewFrameForIndex:ii]];
    }
    
    for (int ii=0; ii< [self.gameDeck count]; ii++)
    {
        [self addSubview:self.draggableViews[ii]];
        [self addSubview:self.droppableViews[ii]];
    }
    
    [self needsDisplay];
}

-(void)checkAnswers:(NSButton*)sender
{
    if ([self gameIsComplete])
    {
        for (NSTextView* view in self.resultsViews)
            [self addSubview:view];
        [self needsDisplay];
    }
    
    [self.checkAnswersButton setEnabled:NO];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [self drawBackground];
    
    for (int ii=0; ii<[self.gameDeck count]; ii++)
    {
        NSView* draggableView = [self.draggableViews objectAtIndex:ii];
        NSView* droppableView = [self.droppableViews objectAtIndex:ii];
        NSTextView* resultsView   = [self.resultsViews objectAtIndex:ii];
        [resultsView setEditable:NO];
        
        if ([self.window inLiveResize] )
        {
            //handle case when draggable view has been dropped in a drop view
            if ( [self.disabledViews containsObject:draggableView] )
            {
                NSInteger indexWhereViewWasDropped = [self.disabledViews indexOfObject:draggableView];
                draggableView.frame = [self calcDroppableViewFrameForIndex:indexWhereViewWasDropped];
            }
            else
            {
                draggableView.frame = [self calcDraggableViewFrameForIndex:ii];
            }
            droppableView.frame = [self calcDroppableViewFrameForIndex:ii];
            resultsView.frame   = [self calcResultsViewFrameForIndex:ii];
        }
        else{//window is not being resized
             //And if view is not being dragged, then call the normal calc... methods
             //to set location of all views, otherwise frames are updated in mouseDragged
            if ( self.viewBeingDragged == nil)
            {
                //again, do nothing if view has been dropped in a drop view since
                //its frame has been updated in mouseUp
                if ( ![self.disabledViews containsObject:draggableView])
                {
                    draggableView.frame = [self calcDraggableViewFrameForIndex:ii];
                    droppableView.frame = [self calcDroppableViewFrameForIndex:ii];
                    resultsView.frame   = [self calcResultsViewFrameForIndex:ii];
                }
            }
        }
        
        [self drawDraggableView:draggableView.frame title:draggableView.identifier];
        [self drawDroppableView:droppableView.frame title:droppableView.identifier ];
        
    }
    
    [self.gameButton setFrame:[self calcGameButtonViewFrame]];
    [self.titleTextView setFrame:[self calcTitleTextViewFrame]];
    
    [self drawTitleTextView:self.titleTextView.frame
                      title:@"Drag and Drop States on to their Capitals"];

}

const float BACKGROUND_GAP = 20.0;

-(void)drawBackground
{
    NSSize viewSize = self.bounds.size;
    [[NSColor whiteColor] set];
    NSRect backgroundRect = NSMakeRect(0+BACKGROUND_GAP,0+BACKGROUND_GAP,
                                       viewSize.width-2*BACKGROUND_GAP,
                                       viewSize.height-2*BACKGROUND_GAP);
    
    NSBezierPath* backgroundPath = [NSBezierPath bezierPathWithRect:backgroundRect];
    [backgroundPath addClip];
    NSRectFill(backgroundRect);
    
    [[NSColor greenColor] set];
    [NSBezierPath strokeRect:backgroundRect];
}


const float DRAG_DROP_WIDTH = 90.0;
const float DRAG_DROP_HEIGHT = 30.0;
const float DRAG_DROP_GAP = 20.0;

-(NSRect)calcDroppableViewFrameForIndex:(NSUInteger)index
{
    
    enum DraggableViewLocation {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT};

    NSPoint viewCenter = NSMakePoint(self.bounds.size.width/2,self.bounds.size.height/2);
    
    NSRect frame;
    
    switch (index) {
        case TOP_LEFT:
            frame = NSMakeRect(viewCenter.x - DRAG_DROP_WIDTH - DRAG_DROP_GAP,
                               viewCenter.y + DRAG_DROP_GAP,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT );
            
            break;
            
        case TOP_RIGHT:
            frame = NSMakeRect(viewCenter.x + DRAG_DROP_GAP,
                               viewCenter.y + DRAG_DROP_GAP,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            break;
            
        case BOTTOM_LEFT:
            frame = NSMakeRect(viewCenter.x - DRAG_DROP_WIDTH - DRAG_DROP_GAP,
                               viewCenter.y - DRAG_DROP_HEIGHT - DRAG_DROP_GAP,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            break;
            
        case BOTTOM_RIGHT:
            frame = NSMakeRect(viewCenter.x + DRAG_DROP_GAP,
                               viewCenter.y - DRAG_DROP_HEIGHT - DRAG_DROP_GAP,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            
        default:
            break;
    }
    
    return frame;

}

-(NSRect)calcDraggableViewFrameForIndex:(NSUInteger)index
{
    enum DroppableViewLocation { FAR_LEFT, CENTER_LEFT, CENTER_RIGHT, FAR_RIGHT };
    
    NSRect frame;
    NSPoint draggableViewCenter = NSMakePoint(self.bounds.size.width/2, 2*DRAG_DROP_GAP);
    
    switch ( index ) {
        case FAR_LEFT:
            frame = NSMakeRect(draggableViewCenter.x - 2*DRAG_DROP_WIDTH - 1.5*DRAG_DROP_GAP,
                               draggableViewCenter.y,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            break;
            
        case CENTER_LEFT:
            frame = NSMakeRect(draggableViewCenter.x - DRAG_DROP_WIDTH - DRAG_DROP_GAP/2,
                               draggableViewCenter.y,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            break;
            
        case CENTER_RIGHT:
            frame = NSMakeRect(draggableViewCenter.x + DRAG_DROP_GAP/2,
                               draggableViewCenter.y,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            break;
            
        case FAR_RIGHT:
            frame = NSMakeRect(draggableViewCenter.x + DRAG_DROP_WIDTH + 1.5*DRAG_DROP_GAP,
                               draggableViewCenter.y,
                               DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
            
            break;
    }
    
    return frame;
}


const float RESULTS_WIDTH = 20;
const float RESULTS_HEIGHT = DRAG_DROP_HEIGHT;
-(NSRect) calcResultsViewFrameForIndex:(NSInteger)index
{
    
    NSPoint frameOrigin = [self calcDroppableViewFrameForIndex:index].origin;
    frameOrigin.x = frameOrigin.x + DRAG_DROP_WIDTH + DRAG_DROP_GAP/2;
    
    return NSMakeRect(frameOrigin.x, frameOrigin.y, RESULTS_WIDTH, RESULTS_HEIGHT);
    
}


-(NSRect)calcGameButtonViewFrame
{
    return NSMakeRect( BACKGROUND_GAP*2, self.bounds.size.height - DRAG_DROP_HEIGHT - BACKGROUND_GAP*2,
                      DRAG_DROP_WIDTH, DRAG_DROP_HEIGHT);
}

-(NSRect)calcTitleTextViewFrame
{
    return NSMakeRect(self.bounds.size.width/2,
                      self.bounds.size.height - 2*BACKGROUND_GAP,
                      0, 0);
   
}


- (void)drawDraggableView:(NSRect)aRect title:(NSString*)title
{
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:5 yRadius:5];
    [[NSColor blueColor] set];
    [path fill];
    
    NSPoint textOrigin = [self textOriginCenterAlignmentInRect:aRect text:title];
    NSDictionary* attributes = @{NSForegroundColorAttributeName: [NSColor whiteColor]};
    [title drawAtPoint:textOrigin withAttributes:attributes];
}

-(void) drawDroppableView:(NSRect)aRect title:(NSString*)title
{
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:5 yRadius:5];
    [path setLineWidth:2];
    CGFloat lineDashArray[2]={6.0,3.0};
    [path setLineDash:lineDashArray count:2 phase:0];
    [[NSColor redColor] set];
    [path stroke];
    
    NSPoint textOrigin = [self textOriginCenterAlignmentInRect:aRect text:title];
    [title drawAtPoint:textOrigin withAttributes:nil];

}

-(void) drawTitleTextView:(NSRect)aRect title:(NSString*)title
{
    NSPoint titleOrigin = [self textOriginCenterAlignmentInRect:aRect text:title];
    NSDictionary* attributes = @{NSForegroundColorAttributeName: [NSColor blackColor]};
    [title drawAtPoint:titleOrigin withAttributes:attributes];
}

/*
 * Helper function to calculate the origin of a text string so that it is centered in aRect
 */
- (NSPoint)textOriginCenterAlignmentInRect:(NSRect)aRect text:(NSString*)text
{
    NSSize textSize = [text sizeWithAttributes:nil];
    NSPoint textOrigin = NSMakePoint(aRect.origin.x + aRect.size.width/2 - textSize.width/2,
                                     aRect.origin.y + aRect.size.height/2 - textSize.height/2);
    return textOrigin;
}


-(void)mouseDown:(NSEvent *)theEvent
{
    self.prevLocation = [theEvent locationInWindow];
    //find which draggable view contains the mouse location
    for (NSView* view in self.draggableViews)
    {
        if ( ![self.disabledViews containsObject:view] )
        {
            BOOL inDraggableView = NSPointInRect(self.prevLocation, view.frame);
            if (inDraggableView)
            {
                self.viewBeingDragged = view;
                self.originalFrame = view.frame;
                break;
            }
        }
    }
}

-(void) mouseUp:(NSEvent *)theEvent
{
    
    NSPoint currentLocation = [theEvent locationInWindow];
    BOOL inDropView = NO;
    for (NSView* dropView in self.droppableViews)
    {
        NSUInteger dropViewIndex = [self.droppableViews indexOfObject:dropView];

        inDropView = NSPointInRect(currentLocation,dropView.frame);
        if (inDropView && self.viewBeingDragged != nil)
        {
            //snap the view being drag into the drop view
            self.viewBeingDragged.frame = dropView.frame;
            
            //instead of simply adding the views to the array, replace the view
            //at the dropViewIndex so that this index can be looked up (drawRect)
            //for the given draggable view
            [self.disabledViews replaceObjectAtIndex:dropViewIndex withObject:self.viewBeingDragged];
            
            //create new item from the dragged and dropped view and check if this item
            //matches the array of data, ie. check if the item's question and answer matches
            Item* item = [[Item alloc] initWithQuestion:self.viewBeingDragged.identifier
                                                 Answer:dropView.identifier];
            
            //Future: call delegate that says the choice was made and it checks and updates view
            if ( [self.gameDeck containsObject:item] )
                [self setCorrect:YES index:dropViewIndex];
            else
                [self setCorrect:NO index:dropViewIndex];

            dropView.identifier = @"";
            self.viewBeingDragged = nil;
            self.numberOfQuestionsAnswered++;
            if ([self gameIsComplete]){
                [self.checkAnswersButton setEnabled:YES];
                [self checkAnswers:nil];
            }
            
            [self needsDisplay];
            break;
        }
    }
    if (!inDropView)
    {
        self.viewBeingDragged.frame = self.originalFrame;
        [self needsDisplay];
    }
}

-(void)setCorrect:(BOOL)correct index:(NSUInteger)index
{
    NSTextView* resultsView = [self.resultsViews objectAtIndex:index];
    NSAttributedString* resultAttrStr;
    if (correct)
    {
        resultAttrStr = [[NSAttributedString alloc]
                         initWithString:@"✔︎"
                         attributes:nil];
        [resultsView setTextColor:[NSColor greenColor]];
    }
    else
    {
        resultAttrStr = [[NSAttributedString alloc]
                         initWithString:@"✘"
                         attributes:nil];
        [resultsView setTextColor:[NSColor redColor]];
    }
    
    resultsView.string = [resultAttrStr string];
}

-(BOOL)gameIsComplete
{
    if ( self.numberOfQuestionsAnswered == [self.gameDeck count])
        return YES;
    else
        return NO;
}

//Future: to be done in the pan gesture
-(void) mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation = [theEvent locationInWindow];
    BOOL inside = NSPointInRect(currentLocation, self.viewBeingDragged.frame);
    if (inside){
        
        NSPoint translationVector = NSMakePoint(currentLocation.x - self.prevLocation.x,
                                                currentLocation.y - self.prevLocation.y);
        [self translateView:self.viewBeingDragged by:translationVector];
    }
    self.prevLocation = currentLocation;
}

-(void)translateView:(NSView*)view by:(NSPoint)delta
{
    view.frame = NSMakeRect(view.frame.origin.x + delta.x,
                            view.frame.origin.y + delta.y,
                            view.frame.size.width,
                            view.frame.size.height);
    [self needsDisplay];
}


@end
