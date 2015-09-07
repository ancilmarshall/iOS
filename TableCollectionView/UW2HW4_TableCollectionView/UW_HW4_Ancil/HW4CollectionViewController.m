//
//  HW4CollectionViewController.m
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/13/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW4CollectionViewController.h"
#import "BirthdayData.h"

@interface HW4CollectionViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation HW4CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor =  [UIColor whiteColor];
    self.navigationItem.title = @"Birthdays";

    // Register cell classes (collection views are made up of cells)
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

//Call inorder to update the UI when switching between tabs
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];  //Always update the UI
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [[BirthdayData sharedInstance] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                  forIndexPath:indexPath];
    NSAssert( cell != nil, @"Expected to have a UICollectionViewCell");
    //bc collection views always guarantees that a properly allocated cell is in
    // the queue, unlike for tableviews
    
    //if a textView subview was previously added to this cell, remove it here
    [[[cell.contentView subviews] firstObject] removeFromSuperview];
    
    //get model data
    NSString* name = [[BirthdayData sharedInstance] nameAtIndex:indexPath.row];
    NSString* date = [[BirthdayData sharedInstance] dateAtIndex:indexPath.row];
    
    //create textView object to add formatted text to a cell
    CGSize cellSize = [self cellSize];
    UITextView* textView = [[UITextView alloc] initWithFrame:
                      CGRectMake(0,0,cellSize.width,cellSize.height)];
    textView.editable = NO;
    
    //create and format the string/text to go inside the cell's textView
    NSDictionary* textAttributes =
        @{NSFontAttributeName:[UIFont systemFontOfSize:20],
          NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSDictionary* detailedTextAttributes =
        @{NSFontAttributeName:[UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName:[UIColor grayColor]};
    
    NSString* text = [NSString stringWithFormat:@"%@\n%@",name,date];
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc]
                                      initWithString:text];
    
    //Call separate attributes on the attributed string based on its range
    [str setAttributes:textAttributes range:NSMakeRange(0, name.length)];
    [str setAttributes:detailedTextAttributes
                range:NSMakeRange(name.length+1, date.length)];
    
    //Note: need to make a mutable paragraph style to change the alignment
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [str addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}
                 range:NSMakeRange(0, [str string].length)];
    
    textView.attributedText = str;
    
    //change border style
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.borderWidth = 1.0f;
    
    //add textView to cell. Remember to remove it at the start of this function
    //since this cell can be reused
    [cell.contentView addSubview:textView];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

//cellSize is a helper function
-(CGSize)cellSize
{
    CGFloat height = 80.0f;
    CGFloat width = self.collectionView.frame.size.width / 2.0f;
    return (CGSize){.width = width, .height=height};
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self cellSize];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return  0.0f;
}

#pragma mark - Rotation support

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView reloadData]; // just update the UI here
}



@end
