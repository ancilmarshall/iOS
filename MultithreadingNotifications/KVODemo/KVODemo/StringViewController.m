//
//  ViewController.m
//  KVODemo
//
//  Created by Tim Ekl on 2015.02.04.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "StringViewController.h"

@interface StringViewController ()

@property (nonatomic, copy) NSString *someString;

@property (weak, nonatomic) IBOutlet UILabel *stringLabel;

@end

@implementation StringViewController

- (IBAction)changeString:(id)sender {
    [self setValue:[self randomString] forKey:@"someString"]; // Set the property with KVC
}

- (NSString *)randomString;
{
    static NSArray *strings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        strings = @[ @"foo", @"bar", @"baz", @"quux" ];
    });
    
    // Ensure we get a different string (for demo purposes)
    NSString *candidate = nil;
    do {
        candidate = strings[arc4random_uniform((uint32_t)strings.count)];
    } while ([candidate isEqualToString:self.someString]);
    return candidate;
}

#pragma mark - UIViewController subclass

- (void)viewDidLoad;
{
    [super viewDidLoad];
    _someString = @"foo";
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [self addObserver:self
           forKeyPath:@"someString"
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior)
              context:&StringViewControllerKVOContext];
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    
    [self removeObserver:self forKeyPath:@"someString" context:&StringViewControllerKVOContext];
}

#pragma mark - KVO

static NSUInteger StringViewControllerKVOContext;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    // Can't unconditionally call super here! Would throw when handling an unexpected keyPath
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    // Instead, check the context for a match against our private static integer
    if (context != &StringViewControllerKVOContext) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    // From this point on, guaranteed that all KVO calls are ones that this class registered for
    NSParameterAssert([keyPath isEqualToString:@"someString"]);
    NSParameterAssert(object == self);
    
    if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
        // Sent before the change occurs
        NSLog(@"about to change old value: %@", change[NSKeyValueChangeOldKey]);
    } else {
        // After the change is committed
        NSLog(@"changed from old string value: %@", change[NSKeyValueChangeOldKey]);
        [self setValue:change[NSKeyValueChangeNewKey]
        forKeyPath:@"stringLabel.text"];
    }
}

@end
