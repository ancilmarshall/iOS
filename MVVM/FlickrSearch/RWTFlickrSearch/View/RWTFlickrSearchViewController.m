//
//  Created by Colin Eberhardt on 13/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWTFlickrSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) RWTFlickrSearchViewModel* viewModel;
@end

@implementation RWTFlickrSearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
  [self bindViewModel];
  
}

// inject the viewModel through the initializer
- (instancetype)initWithViewModel:(RWTFlickrSearchViewModel *)viewModel;
{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)bindViewModel;
{
    self.title = self.viewModel.title;
    
    //binding: view model is notified when view's search text field changes
    RAC(self.viewModel,searchText) = self.searchTextField.rac_textSignal;
    
    //binding: when view's button's is pressed, the RAC command exposed/binded from the viewModel executes
    //A RACCommand is a signal triggered in response to some action, typically UI-related
    self.searchButton.rac_command = self.viewModel.executeSearch;
    
    //binding: when view model has the RACCommand executing, update the shared application's status
    //TODO: Put this in viewModel
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) =
        self.viewModel.executeSearch.executing;
    
    //binding: when the view model has it's RACCommand executing, update the view
    RAC(self.loadingIndicator, hidden) =
    [self.viewModel.executeSearch.executing not];
    
    //binding: when the view model has it's RACCommand executing, update the view using subscribeNext
    [self.viewModel.executeSearch.executionSignals
     subscribeNext:^(id x) {
         [self.searchTextField resignFirstResponder];
     }];
    
}




@end
