//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by Ancil on 12/21/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;

@end

@implementation RWTFlickrSearchImpl


- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *OFSampleAppAPIKey = @"eee9fd786a8e2625cd1da28ea9bba09d";
        NSString *OFSampleAppAPISharedSecret = @"e5a34645def05423";
        
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey
                                                       sharedSecret:OFSampleAppAPISharedSecret];
        _requests = [NSMutableSet new];
    }
    return  self;
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method
                         arguments:(NSDictionary *)args
                         transform:(id (^)(NSDictionary *response))block {
    
    // 1. Create a signal for this request
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 2. Create a Flick request object
        OFFlickrAPIRequest *flickrRequest =
        [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        flickrRequest.delegate = self;
        [self.requests addObject:flickrRequest];
        
        // 3. Create a signal from the delegate method
        RACSignal *successSignal =
        [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:)
                       fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
        // 4. Handle the response
        [[[successSignal
           map:^id(RACTuple *tuple) {
               return tuple.second;
           }]
          map:block]
         subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
        
        // 5. Make the request
        [flickrRequest callAPIMethodWithGET:method
                                  arguments:args];
        
        // 6. When we are done, remove the reference to this request
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:flickrRequest];
        }];
    }];
}

#pragma mark - Flickr Search Protocol

- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
    if (FAKE_WEBSERVICES){
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            RWTFlickrSearchResults* results  = [RWTFlickrSearchResults new];
            results.searchString = @"Fake Results";
            results.totalResults = 0;
            
            RWTFlickrPhoto* photo = [RWTFlickrPhoto new];
            photo.title = @"Fête de la musique";
            NSURL* url = [[NSBundle mainBundle] URLForResource:@"music_festival" withExtension:@"jpg"];
            photo.url = url;
            photo.identifier = @"fake_photo";

            results.photos = @[photo];

            [subscriber sendNext:results];
            [subscriber sendCompleted];
            
            return nil;
            
        }];
        
    } else {
        
    return [self signalFromAPIMethod:@"flickr.photos.search"
                           arguments:@{@"text": searchString,
                                       @"sort": @"interestingness-desc"}
                           transform:^id(NSDictionary *response) {
                               
       RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
       results.searchString = searchString;
       results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
       
       NSArray *photos = [response valueForKeyPath:@"photos.photo"];
       results.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
           RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
           photo.title = [jsonPhoto objectForKey:@"title"];
           photo.identifier = [jsonPhoto objectForKey:@"id"];
           photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto
                                                                   size:OFFlickrSmallSize];
           return photo;
       }];
       
       return results;
   }];
    }
}
@end
