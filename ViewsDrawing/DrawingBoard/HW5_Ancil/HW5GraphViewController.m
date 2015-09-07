//
//  HW5GraphViewController.m
//  HW5_Ancil
//
//  Created by Ancil on 8/10/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW5GraphViewController.h"
#import "HW5GraphView.h"

@interface HW5GraphViewController ()
@end

@implementation HW5GraphViewController

-(id)init
{
    self = [super initWithNibName:self.className bundle:nil];
    return self;
}

- (IBAction)generateNewData:(NSButton *)sender
{
    //TODO: generateNewData should not be in the view? Or should it? 
    [(HW5GraphView*)self.view generateNewData];
    [self.view setNeedsDisplay:YES];
}

@end
