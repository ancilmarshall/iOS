//
//  PhotoTableViewController.m
//  UW_HW6_Ancil
//
//  Created by Ancil on 12/16/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "PhotoCollectionViewController.h"
#import <Photos/Photos.h>

static NSString* const kCellIdentifier = @"Cell";

//make a custom cell so that I can set the UITableViewCellStyle
//NOTE: only way to do this without a nib or Interface Builder
@interface PhotoTableViewCell : UITableViewCell
@end

@implementation PhotoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
}

@end


@interface PhotoTableViewController ()
@property (nonatomic,strong) PHFetchResult* albumsFetchResult;
@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Photos",nil);
    
    //setup tableview
    [self.tableView registerClass:[PhotoTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    
    //check for authorization, which prompts user. The user's choice is in status
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized){
            return;
        }
        
        //fetch photo asset collection from library by assetcollection type
        self.albumsFetchResult =
        [PHAssetCollection
         fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
         subtype:PHAssetCollectionSubtypeAny
         options:nil];
        
         //since it is not guaranteed that this block is running on main queue,
         //explicitly upload the tableview UI on the main queue
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.albumsFetchResult count];
}

- (PhotoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert(self.tableView == tableView,@"Expect self.tableview to be passed in to this delegate");
    
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    PHAssetCollection* collection = self.albumsFetchResult[indexPath.row];
    cell.textLabel.text = collection.localizedTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //find how many items are in the collection, and add as a detail
    PHFetchResult* assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    NSUInteger numberOfAssets = [assets count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%tu",numberOfAssets];
    
    return cell;
}


#pragma mark - TableView delegate 

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHAssetCollection* album = self.albumsFetchResult[indexPath.row];
    PhotoCollectionViewController* collectionViewController =
        [[PhotoCollectionViewController alloc]
         initWithCollectionViewLayout:[UICollectionViewFlowLayout new]]; // remember flowlayout
    collectionViewController.album = album; //needed to be set
    
    //since this UITableViewController is embedded in a NavigationController, can call pushViewController
    [self.navigationController pushViewController:collectionViewController animated:YES];
    
}

@end
