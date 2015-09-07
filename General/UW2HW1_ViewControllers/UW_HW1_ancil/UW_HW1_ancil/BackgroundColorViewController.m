//
//  BackgroundColorViewController.m
//  UW_HW1_ancil
//
//  Created by Ancil on 10/2/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "BackgroundColorViewController.h"

@interface BackgroundColorViewController ()
@property (nonatomic,strong) UIColor* color;
@property (nonatomic) NSUInteger count;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@end


@implementation BackgroundColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = _color;
    self.displayLabel.text =
        [NSString stringWithFormat:@"Display count: %tu",_count];
}

-(instancetype)initWithColor:(UIColor *)color count:(NSUInteger)count
{
    self = [super init];
    if (self)
    {
        self.color = color;
        self.count = count;
    }
    return self;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
