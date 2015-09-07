//
//  HW4TableViewController.m
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/13/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW4TableViewController.h"
#import "HW4AddBirthdayViewController.h"
#import "BirthdayData.h"

static NSString* const kTableViewCellIdentifier = @"tableViewCell";

#pragma mark - Private Custom TableViewCell inorder to override the cell style
@interface MyTableViewCell : UITableViewCell
@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:UITableViewCellStyleValue1
              reuseIdentifier:reuseIdentifier];
  return self;
}
@end

#pragma mark - HW4TableViewController

@interface HW4TableViewController ()
@end

@implementation HW4TableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"Birthdays";
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                           target:self
                                           action:@selector(addBirthday:)];
  
  [self.tableView registerClass:[MyTableViewCell class]
         forCellReuseIdentifier:kTableViewCellIdentifier];
  self.tableView.allowsSelection = NO;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

#pragma mark - Birthday methods
- (void) addBirthday:(id)sender
{
  if (self.tableView.editing == NO) {
    HW4AddBirthdayViewController* addBirthdayVC = [HW4AddBirthdayViewController new];
    [self presentViewController:addBirthdayVC animated:YES completion:nil];
  }
  else{
    [self showAlert];
  }
}

// show alert if table in editing mode
- (void) showAlert
{
  UIAlertController* alertController = [UIAlertController
                                        alertControllerWithTitle:@"Table in Editing Mode"
                                        message:@"Cannot Add to Table while Editing"
                                        preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                   }];
  
  [alertController addAction:okAction];
  [alertController setModalPresentationStyle:UIModalPresentationNone];
  [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[BirthdayData sharedInstance] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
  
  cell.textLabel.text = [[BirthdayData sharedInstance] nameAtIndex:indexPath.row];
  cell.detailTextLabel.text = [[BirthdayData sharedInstance] dateAtIndex:indexPath.row];
  
  return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    //NOTE: must update the data first before calling deleteRowsAtIndexPaths ...
    [[BirthdayData sharedInstance] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}


@end
