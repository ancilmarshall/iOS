//
//  DataTabViewController.m
//  UW_HW1_ancil
//
//  Created by Ancil on 10/2/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "DataTabViewController.h"
#import "ModelData.h"

@interface DataTabViewController ()
@property (nonatomic,strong) ModelData* data;
@property (weak, nonatomic) IBOutlet UILabel *redCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *customCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomCountLabel;

@end

@implementation DataTabViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateGui];
}

-(instancetype)initWithData:(ModelData *)data
{
    self = [super init];
    if (self) {
        self.data = data;
        self.tabBarItem.title = @"Data";
        self.tabBarItem.image = [UIImage imageNamed:@"data"];
    }
    return self;
}
- (IBAction)reset:(UIButton *)sender {
    
    UIAlertController* alertController = [UIAlertController
                                alertControllerWithTitle:@"Reset Data"
                                message:@"Are you sure you want to reset all data?"
                                preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action) {
                                    [self.data resetCounts];
                                    [self updateGui];
                                }];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction *action) {
                         //[self dismissViewControllerAnimated:YES completion:nil];
                    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void) updateGui
{
    self.redCountLabel.text = [NSString stringWithFormat:@"%tu",self.data.redCount];
    self.greenCountLabel.text = [NSString stringWithFormat:@"%tu",self.data.greenCount];
    self.blueCountLabel.text = [NSString stringWithFormat:@"%tu",self.data.blueCount];
    self.customCountLabel.text = [NSString stringWithFormat:@"%tu",self.data.customCount];
    self.randomCountLabel.text = [NSString stringWithFormat:@"%tu",self.data.randomCount];
}

@end
