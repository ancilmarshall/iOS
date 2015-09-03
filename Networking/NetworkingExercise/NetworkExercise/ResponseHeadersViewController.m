//
//  ResponseHeadersViewController.m
//  NetworkExercise
//
//  Created by Tim Ekl on 2/11/15.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "ResponseHeadersViewController.h"

@interface HTTPHeader : NSObject
@property (nonatomic, copy) NSString *headerName;
@property (nonatomic, copy) NSString *headerValue;
+ (instancetype)headerWithName:(NSString *)name value:(NSString *)value;
@end

@implementation HTTPHeader

+ (instancetype)headerWithName:(NSString *)name value:(NSString *)value;
{
    HTTPHeader *result = [[self alloc] init];
    result.headerName = name;
    result.headerValue = value;
    return result;
}

@end

#pragma mark -

@interface ResponseHeadersViewController ()

@property (nonatomic, copy) NSArray *HTTPHeaders;

@end

@implementation ResponseHeadersViewController


-(instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    
    if (self){
        
        self.HTTPHeaders = @[];
        
        [[NSNotificationCenter defaultCenter]
         addObserverForName:ResponseViewHTTPURLHeadersNotificationName
         object:nil
         queue:[NSOperationQueue mainQueue]
         
         usingBlock:^(NSNotification *note) {
             
             NSAssert([note.object isKindOfClass:[NSDictionary class]],@"");
             NSDictionary* headers = (NSDictionary*)note.object;
             
             NSMutableArray* httpHeadersArray = [NSMutableArray new];
             
             NSArray* allHeaderKeys = [headers allKeys];
             for (NSString* name in allHeaderKeys) {
                 
                 [httpHeadersArray addObject:[HTTPHeader headerWithName:name
                                                                  value:headers[name]]];
                 
             }
             
             self.HTTPHeaders = [httpHeadersArray copy];
             [self.tableView reloadData];
         }];
    }
    
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.HTTPHeaders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.HTTPHeaders[indexPath.row] headerName];
    cell.detailTextLabel.text = [self.HTTPHeaders[indexPath.row] headerValue];
    return cell;
}

@end
