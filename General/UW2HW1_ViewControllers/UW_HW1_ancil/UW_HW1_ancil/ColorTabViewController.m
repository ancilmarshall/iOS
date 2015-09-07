//
//  ColorTabViewController.m
//  UW_HW1_ancil
//
//  Created by Ancil on 10/2/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "BackgroundColorViewController.h"
#import "ColorTabViewController.h"
#import "DataTabViewController.h"
#import "ModelData.h"
#import "UIColor+UWExtensions.h"

@interface ColorTabViewController ()
@property (weak, nonatomic) IBOutlet UITextField *redInputColor;
@property (weak, nonatomic) IBOutlet UITextField *greenInputColor;
@property (weak, nonatomic) IBOutlet UITextField *blueInputColor;
@property (nonatomic, strong) ModelData* data;
@end

@implementation ColorTabViewController

//declare C-style function
double maxValue(double, double, double);

-(instancetype)initWithData:(ModelData *)data
{
    self = [super init];
    if (self) {
        self.data = data;
        self.tabBarItem.title = @"Colors";
        self.tabBarItem.image = [UIImage imageNamed:@"colors"];
    }
    return self;
}

- (IBAction)ColorButtonPressed:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"Red"])
    {
        [self.data updateCountForColor:@"Red"];
        [self presentViewController:[[BackgroundColorViewController alloc]
                                     initWithColor:[UIColor redColor]
                                     count:self.data.redCount]
                           animated:YES
                         completion:nil];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Green"])
    {
        [self.data updateCountForColor:@"Green"];
        [self presentViewController:[[BackgroundColorViewController alloc]
                                     initWithColor:[UIColor greenColor]
                                     count:self.data.greenCount]
                           animated:YES
                         completion:nil];
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"Blue"])
    {
        [self.data updateCountForColor:@"Blue"];
        [self presentViewController:[[BackgroundColorViewController alloc]
                                     initWithColor:[UIColor blueColor]
                                     count:self.data.blueCount]
                           animated:YES
                         completion:nil];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Custom"])
    {
        
        NSNumberFormatter* numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber* red = [numFormatter numberFromString:self.redInputColor.text];
        NSNumber* green = [numFormatter numberFromString:self.greenInputColor.text];
        NSNumber* blue = [numFormatter numberFromString:self.blueInputColor.text];

        if ( red && green && blue )
        {
            [self.data updateCountForColor:@"Custom"];
            
            double redValue = [red doubleValue];
            double greenValue = [green doubleValue];
            double blueValue = [blue doubleValue];
            
            double den = maxValue(redValue,greenValue,blueValue);
            redValue /= den;
            greenValue /= den;
            blueValue /= den;
            
            [self presentViewController:[[BackgroundColorViewController alloc]
                     initWithColor:[UIColor colorWithRed:redValue
                                                   green:greenValue
                                                    blue:blueValue
                                                   alpha:1.0]
                             count:self.data.customCount]
                               animated:YES
                             completion:nil];
        }
        else{
            UIAlertController* alert =
                [UIAlertController
                alertControllerWithTitle:@"Missing Custom Value"
                                 message:@"Please fill in missing custom values"
                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                     style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction *action) {
                       [self dismissViewControllerAnimated:YES completion:nil];
                   }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }
    else if ([sender.titleLabel.text isEqualToString:@"Random"])
    {
        [self.data updateCountForColor:@"Random"];
        [self presentViewController:[[BackgroundColorViewController alloc]
                                     initWithColor:[UIColor randomRGBColor]
                                     count:self.data.randomCount]
                           animated:YES
                         completion:nil];
    }
    else {
        NSAssert(false, @"Unsupported UIButton title pressed");
    }
}

//define C-style maxValue function
double maxValue(double first, double second, double third)
{
    double max = first;
    if (second > max)
        max = second;
    if (third > max)
        max = third;
    return max;
}


@end
