//
//  ViewController.m
//  OperationsBackgroundingExercise
//
//  Created by Tim Ekl on 2015.02.04.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "OperationsViewController.h"

#if 1 && defined(DEBUG)
#define OPERATION_LOG(format, ...) NSLog(@"OPERATION: " format, ## __VA_ARGS__)
#else
#define OPERATION_LOG(format, ...)
#endif

static const NSInteger OperationsViewControllerAddOperationTagOffset = 1000;

@interface OperationsViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *operationCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *concurrentOperationsLabel;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (atomic, assign) UIBackgroundTaskIdentifier backgroundOperationTask;

@end

static NSUInteger OperationsViewControllerQueueKVOContext;

@implementation OperationsViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.name = @"OperationsViewControllerQueue";
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    self.backgroundOperationTask = UIBackgroundTaskInvalid; // initialize to invalid so we don't inadvertently kill real background tasks or fail assertions later
    
    [self.operationQueue addObserver:self
                          forKeyPath:NSStringFromSelector(@selector(operationCount))
                             options:NSKeyValueObservingOptionInitial
                             context:&OperationsViewControllerQueueKVOContext];
    [self.operationQueue addObserver:self
                          forKeyPath:NSStringFromSelector(@selector(maxConcurrentOperationCount))
                             options:NSKeyValueObservingOptionInitial
                             context:&OperationsViewControllerQueueKVOContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)dealloc;
{
    // Don't remove observers if they haven't been registered – and we register in -viewDidLoad
    if ([self isViewLoaded]) {
        [self.operationQueue removeObserver:self
                                 forKeyPath:NSStringFromSelector(@selector(maxConcurrentOperationCount))
                                    context:&OperationsViewControllerQueueKVOContext];
        [self.operationQueue removeObserver:self
                                 forKeyPath:NSStringFromSelector(@selector(operationCount))
                                    context:&OperationsViewControllerQueueKVOContext];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:[UIApplication sharedApplication]];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:[UIApplication sharedApplication]];
    }
}

#pragma mark - Actions

- (IBAction)addOperations:(id)sender;
{
    NSParameterAssert([sender isKindOfClass:[UIButton class]]);
    NSParameterAssert([sender tag] > OperationsViewControllerAddOperationTagOffset);
    NSAssert(self.operationQueue != nil, @"Can't add operations without a queue");
    
    NSInteger operationCount = [sender tag] - OperationsViewControllerAddOperationTagOffset;
    for (NSInteger i = 0; i < operationCount; i++) {
        [self.operationQueue addOperationWithBlock:^{
            sleep(1 + arc4random_uniform(3));
        }];
    }
}

- (IBAction)changeConcurrentOperationCount:(id)sender {
    NSParameterAssert([sender isKindOfClass:[UIStepper class]]);
    self.operationQueue.maxConcurrentOperationCount = [(UIStepper *)sender value];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (context != &OperationsViewControllerQueueKVOContext) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    NSParameterAssert(object == self.operationQueue);
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(operationCount))]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateOperationCountLabel];
        });
        
        if (self.backgroundOperationTask != UIBackgroundTaskInvalid) {
            // In the background with an active task – log out some state
            if ([self.operationQueue operationCount] == 0) {
                OPERATION_LOG(@"Operations completed; ending background task");
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundOperationTask];
                self.backgroundOperationTask = UIBackgroundTaskInvalid;
            } else {
                OPERATION_LOG(@"Waiting for %tu more operations...", [self.operationQueue operationCount]);
            }
        }
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(maxConcurrentOperationCount))]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateConcurrentOperationsLabel];
        });
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Unexpected key path in KVO handler: %@", keyPath]
                                     userInfo:nil];
    }
}

#pragma mark - Private

- (void)updateOperationCountLabel;
{
    NSAssert([NSThread isMainThread], @"Only update UI on the main thread");
    NSAssert([self isViewLoaded], @"Can't update UI that hasn't yet been loaded");
    
    NSUInteger opCount = [self.operationQueue operationCount];
    switch (opCount) {
        case 0:
            self.operationCountLabel.text = NSLocalizedString(@"No operations", nil);
            break;

        case 1:
            self.operationCountLabel.text = NSLocalizedString(@"1 operation remaining", nil);
            break;
            
        default:
            self.operationCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%tu operations remaining", nil), opCount];
            break;
    }
}

- (void)updateConcurrentOperationsLabel;
{
    NSAssert([NSThread isMainThread], @"Only update UI on the main thread");
    NSAssert([self isViewLoaded], @"Can't update UI that hasn't yet been loaded");
    
    NSInteger concurrentCount = self.operationQueue.maxConcurrentOperationCount;
    switch (concurrentCount) {
        case 1:
            self.concurrentOperationsLabel.text = NSLocalizedString(@"1 concurrent op", nil);
            break;
            
        default:
            self.concurrentOperationsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%tu concurrent ops", nil), concurrentCount];
            break;
    }
}

#pragma mark App lifecycle

- (void)appDidBackground:(NSNotification *)notification;
{
    if ([self.operationQueue operationCount] > 0) {
        NSAssert(self.backgroundOperationTask == UIBackgroundTaskInvalid, @"Should never take out two BG tasks for the one queue");
        
        OPERATION_LOG(@"App backgrounding; taking out background task");
        UIApplication *app = [UIApplication sharedApplication];
        self.backgroundOperationTask = [app beginBackgroundTaskWithExpirationHandler:^{
            OPERATION_LOG(@"Background task expiring; ending early");
            [app endBackgroundTask:self.backgroundOperationTask];
            self.backgroundOperationTask = UIBackgroundTaskInvalid;
        }];
    }
}

- (void)appWillForeground:(NSNotification *)notification;
{
    if (self.backgroundOperationTask != UIBackgroundTaskInvalid) {
        OPERATION_LOG(@"App foregrounding; giving up background task");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundOperationTask];
        self.backgroundOperationTask = UIBackgroundTaskInvalid;
    }
}

@end
