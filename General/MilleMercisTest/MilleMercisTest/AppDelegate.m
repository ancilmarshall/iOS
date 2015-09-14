//
//  AppDelegate.m
//  MilleMercisTest
//
//  Created by Ancil on 9/9/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"

static NSString * const AppDelegateBackgroundDownloadIdentifier = @"AppDelegateBackgroundDownload";

@interface AppDelegate () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSOperationQueue *backgroundDownloadQueue;
@property (nonatomic, strong) NSURLSession *backgroundDownloadSession;
@property (nonatomic, strong) void (^backgroundDownloadCompletionHandler)(void);

@property (nonatomic, strong) PhotoViewController *imageViewController;

@end

@implementation AppDelegate

+ (instancetype)delegate;
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewController:(PhotoViewController*)viewController  beginBackgroundDownloadForURL:(NSURL*)url;
{
    //check if we need a background task, if so create it
    [self createBackgroundDownloadSessionIfNeeded];
    
    //set viewcontroller
    self.imageViewController = viewController;
    
    NSURLSessionDownloadTask *downloadTask =
        [self.backgroundDownloadSession downloadTaskWithURL:url];
    [downloadTask resume];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Check when the app is launched if there is an image available to display since
    // this could have been downloaded in the background by the system
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self cachedImageURL] path]]) {
        //[self setImageOnViewController];
    }
    
    return YES;
}

/*
 * This function is called by the system when it wakes up our app into the background
 * to handle some background url session. The system actually passes us the completion
 * handler so that we can call it when we are finished, which in turn calls the system
 * to let it know we are finished. Its a hook back into the system.
 */

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler;
{
    
    //ensure that we are waken up with the correct identifier.
    NSParameterAssert([identifier isEqualToString:AppDelegateBackgroundDownloadIdentifier]);
    
    //create the same background session with this identifier.
    [self createBackgroundDownloadSessionIfNeeded];
    
    //hold on to the completion handler for later use, since we are not ready yet
    self.backgroundDownloadCompletionHandler = completionHandler;
}

#pragma mark - NSURLSessionDownloadDelegate
/*
 * This function gets called when the download task is complete. Here we must move
 * the data from the temporary url to a permanent location in the app's container
 * This can be called in the background or foreground.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location;
{
    
    NSError* error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[self cachedImageURL] error:&error];

    if (error != nil){
        NSLog(@"Error moving downloaded file to cache");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImageOnViewController];
    });
}

#pragma mark - NSURLSessionDelegate

/*
 * This is a regular event that happens when the background url session is complete
 * Here we need to call the completion handler that was passed to use by the system
 * so that the system knows we are finished handling the background events. The system
 * can then complete it's own tasks, and wrap up the background session stuff.
 * Note that this is when all the events for this session is complete, ie. it could
 * be several download tasks which are handled by the download delegate.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;
{
    NSParameterAssert(session == self.backgroundDownloadSession);
    
    NSAssert(self.backgroundDownloadCompletionHandler != nil, @"When finishing background events, expected to have a completion handler");
    self.backgroundDownloadCompletionHandler();
    self.backgroundDownloadCompletionHandler = nil;
}


#pragma mark - Private
/*
 * Here is where the background session is created. It uses the delegate and delegate
 * queue api to perform the task in the background
 */
- (void)createBackgroundDownloadSessionIfNeeded;
{
    if (self.backgroundDownloadSession != nil) {
        return;
    }
    
    self.backgroundDownloadQueue = [[NSOperationQueue alloc] init];
    self.backgroundDownloadQueue.name = AppDelegateBackgroundDownloadIdentifier;
    
    NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:AppDelegateBackgroundDownloadIdentifier];
    self.backgroundDownloadSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                   delegate:self
              delegateQueue:self.backgroundDownloadQueue];
}

- (NSURL *)cachedImageURL;
{
    return [[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                    inDomain:NSUserDomainMask
                                           appropriateForURL:nil
                                                      create:NO
                                                       error:NULL]
             URLByAppendingPathComponent:@"image"]
            URLByAppendingPathExtension:@"jpg"];
}

- (void)cleanUpCachedImage;
{
    
    NSURL* url = [self cachedImageURL];
    
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    
    if (error != nil){
        NSLog(@"Error deleting cache.");
    }
    
}


- (void)setImageOnViewController;
{
    NSData *data = [NSData dataWithContentsOfURL:[self cachedImageURL]];
    UIImage *image = [UIImage imageWithData:data];
    [self.imageViewController setImage:image];
    [self cleanUpCachedImage];
}


@end
