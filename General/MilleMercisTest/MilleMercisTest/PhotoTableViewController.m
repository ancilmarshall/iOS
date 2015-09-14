//
//  PhotoTableViewController.m
//  MilleMercisTest
//
//  Created by Ancil on 9/9/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "PhotoViewController.h"

@interface PhotoData : NSObject
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* url;
@end

@implementation PhotoData
@end

@interface PhotoTableViewController ()
@property (nonatomic,strong) NSArray* photos;
@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // These 2 methods work just fine. First uses a url, second a path as a string
    // NSURL* url = [[NSBundle mainBundle] URLForResource:@"photos" withExtension:@"plist"];
    // NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:url];
    
    NSString* url = [[NSBundle mainBundle] pathForResource:@"photos" ofType:@"plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:url];
    
    NSMutableArray* tempArray = [NSMutableArray new];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSDictionary* value, BOOL *stop) {
        
        __block PhotoData* newPhotoData = [PhotoData new];
        
        // nice use of KVC here to set the data. PhotoData should be setup to match the plist
        [value enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL *stop) {
            [newPhotoData setValue:value forKey:key];
        }];
        
        [tempArray addObject:newPhotoData];
    }];
    
    self.photos = [NSArray arrayWithArray:tempArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    PhotoData* data = self.photos[indexPath.row];
    cell.textLabel.text = data.title;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    PhotoData* data = self.photos[[self.tableView indexPathForSelectedRow].row];
    PhotoViewController* vc = [segue destinationViewController];
    vc.url = [NSURL URLWithString:data.url];
    vc.imageTitle = data.title;
}


@end
