//
//  AppDelegate.m
//  BackgroundDownloadDemo
//
//  Created by Tim Ekl on 2015.02.09.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"
#import "DownloadedImageViewController.h"

static NSString * const AppDelegateBackgroundDownloadIdentifier = @"AppDelegateBackgroundDownload";

@interface AppDelegate () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSOperationQueue *backgroundDownloadQueue;
@property (nonatomic, strong) NSURLSession *backgroundDownloadSession;
@property (nonatomic, strong) void (^backgroundDownloadCompletionHandler)(void);

@property (nonatomic, strong, readonly) DownloadedImageViewController *imageViewController;

@end

@implementation AppDelegate

+ (instancetype)delegate;
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)beginBackgroundDownload;
{
    //check if we need a background task, if so create it
    [self createBackgroundDownloadSessionIfNeeded];
    
    NSURL *URL = [NSURL URLWithString:@"http://apod.nasa.gov/apod/image/1502/m104colombari_q100_watermark.jpg"];
    
    //Note that we avoid explicitly the methods to create a download task that have
    //the completion block syntax because we want to go through the file system
    //so that the downloads can happen in the background
    NSURLSessionDownloadTask *downloadTask = [self.backgroundDownloadSession downloadTaskWithURL:URL];
    [downloadTask resume];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Check when the app is launched if there is an image available to display since
    // this could have been downloaded in the background by the system, and we enter here when
    // we launch normally with the UI active
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self cachedImageURL] path]]) {
        [self setImageOnViewController];
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
    
    //create the same background session with this identifier. When this is created, then we
    //started getting the delegate calls for the tasks
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
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[self cachedImageURL] error:NULL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImageOnViewController];
    });
}

#pragma mark - NSURLSessionDelegate

/*
 * This is a regular event that happens when the background url session is complete
 * Here we need to call the completion handler that was passed to us by the system
 * so that the system knows we are finished handling the background events. The system
 * can then complete it's own tasks, and wrap up the background session stuff.
 * Note that this is when all the events for this session is complete, ie. it could
 * be several download tasks which are handled by the download delegate.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;
{
    NSParameterAssert(session == self.backgroundDownloadSession);
    
    NSAssert(self.backgroundDownloadCompletionHandler != nil, @"When finishing background events, expected to have a completion handler");
    
    //must call the completion handler on the main thread, especially because it is
    //part of UIKit, which must always occur on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backgroundDownloadCompletionHandler();
    });
    self.backgroundDownloadCompletionHandler = nil;
}

#pragma mark - Private
/*
 * Here is where the background session is created. It uses the delegate and delegate
 * queue api to perform the task in the background. Note, we don't really need to create
 * this session when the app is first launch, but only when it is necessary.
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

- (DownloadedImageViewController *)imageViewController;
{
    UIViewController *rootVC = [self.window rootViewController];
    //we check for nil here for the case where we launch in the background to handle the download
    //event, but we really have no UI
    NSAssert(rootVC == nil || [rootVC isKindOfClass:[DownloadedImageViewController class]], nil);
    return (DownloadedImageViewController *)rootVC;
}

- (void)setImageOnViewController;
{
    NSData *data = [NSData dataWithContentsOfURL:[self cachedImageURL]];
    UIImage *image = [UIImage imageWithData:data];
    [self.imageViewController setImage:image];
}

@end
