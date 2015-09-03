//
//  ResponseContentViewController.m
//  NetworkExercise
//
//  Created by Tim Ekl on 2/11/15.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "ResponseContentsViewController.h"


@interface ResponseContentsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (nonatomic,strong) NSString* contents;
@end

@implementation ResponseContentsViewController

// TODO #2: When a network request finishes (after being sent from the RequestViewController), update the contentsTextView with the received data (or an error message if appropriate).

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    
    if (self){
        self.contents = [NSString new];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(handleResponseContentsNotification:)
         name:ResponseViewDataNotificationName
         object:nil];
        
    }
    
    return self;
}

-(void)handleResponseContentsNotification:(NSNotification*)note;
{
    NSAssert([note.object isKindOfClass:[NSString class]],@"");
    NSString* noteString = (NSString*)note.object;
    self.contents = noteString;
    [self updateUI];
    
}

-(void)updateUI;
{
    self.contentsTextView.text = self.contents;
}

-(void)viewDidLoad;
{
    [super viewDidLoad];
    [self updateUI];
}

@end
