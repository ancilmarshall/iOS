//
//  OperationViewController.m
//  OperationViewer
//
//  Created by Tim Ekl on 1/25/14.
//  Copyright (c) 2014 Tim Ekl. All rights reserved.
//

#import "OperationViewController.h"

#import "CancelTableCellView.h"
#import "Operation.h"

NSString const * OperationType = @"com.lithium3141.operation";

typedef NS_ENUM(NSUInteger, OperationTableViewColumn) {
    OperationTableViewColumnName = 0,
    OperationTableViewColumnDependencies,
    OperationTableViewColumnTime,
    OperationTableViewColumnState,
    OperationTableViewColumnCancel,
};

@interface OperationViewController () <NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic, weak) IBOutlet NSTextField *queueNameField;

@property (nonatomic, weak) IBOutlet NSTextField *concurrentOperationsField;
@property (nonatomic, weak) IBOutlet NSStepper *concurrentOperationsStepper;
@property (nonatomic, weak) IBOutlet NSButton *queueSuspendedButton;

@property (nonatomic, weak) IBOutlet NSTextField *operationNameField;
@property (nonatomic, weak) IBOutlet NSTextField *operationTimeField;
@property (nonatomic, weak) IBOutlet NSStepper *operationTimeStepper;

@property (nonatomic, assign) NSUInteger autogeneratedOperationIndex;

@end

@implementation OperationViewController

- (id)init;
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)awakeFromNib;
{
    [super awakeFromNib];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self toggleSuspensionState:nil];
    [self concurrentOperationsChanged:self.concurrentOperationsStepper]; // the stepper has the right initial value
    
    [self.operationQueue addObserver:self forKeyPath:@"name" options:0 context:&OperationViewControllerQueueKVOContext];
    [self.operationQueue addObserver:self forKeyPath:@"operations" options:0 context:&OperationViewControllerQueueKVOContext];
    
    //call the delegate to get the OperationQueue name
    self.operationQueue.name = [self.delegate nameForNewOperationQueue:self];
    
    [self.tableView registerForDraggedTypes:@[ OperationType ]];
}

- (void)dealloc;
{
    [self.operationQueue removeObserver:self forKeyPath:@"operations" context:&OperationViewControllerQueueKVOContext];
    [self.operationQueue removeObserver:self forKeyPath:@"name" context:&OperationViewControllerQueueKVOContext];
}

- (NSString *)operationQueueName;
{
    return self.operationQueue.name;
}

- (NSArray *)operations;
{
    return self.operationQueue.operations;
}

#pragma mark - Actions

- (IBAction)addOperation:(id)sender;
{
    NSString *operationName = [self.operationNameField stringValue];
    if ([operationName length] == 0) {
        operationName = [self _nameForNewOperation];
    }
    
    Operation *operation = [[Operation alloc] init];
    operation.name = operationName;
    operation.time = (NSTimeInterval)[self.operationTimeField doubleValue];
    
    for (NSString *keyPath in [self _observedOperationKeyPaths]) {
        [operation addObserver:self
                    forKeyPath:keyPath
                       options:0
                       context:&OperationViewControllerOperationKVOContext];
    }
    
    [self.operationQueue addOperation:operation];
}

- (IBAction)concurrentOperationsChanged:(id)sender;
{
    NSInteger count = [sender integerValue];
    self.operationQueue.maxConcurrentOperationCount = count;
    
    self.concurrentOperationsField.integerValue = count;
    self.concurrentOperationsStepper.integerValue = count;
}

- (IBAction)toggleSuspensionState:(id)sender;
{
    self.operationQueue.suspended = ![self.operationQueue isSuspended];
    
    if ([self.operationQueue isSuspended]) {
        self.queueSuspendedButton.title = NSLocalizedString(@"Resume", @"resume queue button title");
    } else {
        self.queueSuspendedButton.title = NSLocalizedString(@"Suspend", @"suspend queue button title");
    }
}

- (void)cancelButtonClicked:(id)sender;
{
    NSParameterAssert([sender isKindOfClass:[NSButton class]]);
    NSParameterAssert([sender isDescendantOf:self.tableView]);
    
    NSInteger row = [self.tableView rowForView:sender];
    NSAssert(row < self.operationQueue.operationCount, @"Shouldn't be able to cancel an operation not in the queue");
    Operation *operation = self.operationQueue.operations[row];
    [operation cancel];
}

#pragma mark - KVO

//Tricky way of defining some variable so that the change context can be matched
static NSUInteger OperationViewControllerQueueKVOContext;
static NSUInteger OperationViewControllerOperationKVOContext;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (context == &OperationViewControllerQueueKVOContext) {
        
        NSParameterAssert(object == self.operationQueue);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([keyPath isEqualToString:@"name"]) {
                self.queueNameField.stringValue = self.operationQueue.name;
            } else if ([keyPath isEqualToString:@"operations"]) {
                [self.tableView reloadData];
            }
        });
        
    } else if (context == &OperationViewControllerOperationKVOContext) {
        
        NSOperation *operation = (NSOperation *)object;
        
        NSInteger operationIndex = [[self.operationQueue operations] indexOfObject:operation];
        if (operationIndex == NSNotFound)
            return;
        
        NSInteger columnIndex = NSNotFound;
        
        if ([keyPath isEqualToString:@"dependencies"]) {
            columnIndex = OperationTableViewColumnDependencies;
        } else {
            columnIndex = OperationTableViewColumnState;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:operationIndex]
                                      columnIndexes:[NSIndexSet indexSetWithIndex:columnIndex]];
        });
    
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    NSParameterAssert(tableView == self.tableView);
    return [self.operationQueue operationCount];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{
    NSParameterAssert(tableView == self.tableView);
    
    // Gotta check this, since we dispatch_async() some table view reloads – the op queue might've changed its operations set out from under us
    // (Sure would be nice if the queue could send KVO change kinds other than NSKeyValueChangeSetting for its operations key, but oh well...)
    if (row >= [self.operationQueue operationCount])
        return nil;
    
    Operation *operation = self.operationQueue.operations[row];
    OperationTableViewColumn column = [self.tableView.tableColumns indexOfObject:tableColumn];
    
    NSString *identifier = [self _cellIdentifierForColumn:column];
    NSTableCellView *cell = [self.tableView makeViewWithIdentifier:identifier owner:nil];
    
    switch (column) {
        case OperationTableViewColumnName:
            cell.textField.stringValue = operation.name;
            break;
        case OperationTableViewColumnDependencies:
            cell.textField.stringValue = [self _displayStringForDependenciesForOperation:operation];
            break;
        case OperationTableViewColumnState:
            cell.textField.stringValue = [self _displayStringForStateForOperation:operation];
            break;
        case OperationTableViewColumnTime:
            cell.textField.integerValue = operation.time;
            break;
        case OperationTableViewColumnCancel:
            [((CancelTableCellView *)cell).cancelButton setTarget:self];
            [((CancelTableCellView *)cell).cancelButton setAction:@selector(cancelButtonClicked:)];
            break;
    }
    
    return cell;
}

#pragma mark Drag & drop

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation;
{
    Operation *draggedOperation = [self _operationFromDragInfo:info];
    if (draggedOperation == nil)
        return NO;
    
    Operation *targetOperation = self.operationQueue.operations[row];
    [targetOperation addDependency:draggedOperation];
    
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation;
{
    // Only allow drops on cells, not above (between)
    if (dropOperation == NSTableViewDropAbove)
        return NSDragOperationNone;
    
    // Shouldn't be able to drop outside the available operations list
    if (row >= self.operationQueue.operationCount)
        return NSDragOperationNone;
    
    // Don't accept drops from outside the app (can't establish the dependency)
    if ([info draggingSource] == nil)
        return NSDragOperationNone;
    
    // Make sure this queue isn't running, just for simplicity
    if (![self.operationQueue isSuspended])
        return NSDragOperationNone;
    
    // Can't accept drags if we don't know how to translate them into operations
    Operation *draggedOperation = [self _operationFromDragInfo:info];
    if (draggedOperation == nil)
        return NSDragOperationNone;
    
    // ...or if that operation would become its own dependency
    if ([self _operation:draggedOperation isDependentOn:self.operationQueue.operations[row]])
        return NSDragOperationNone;
    
    return NSDragOperationLink;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard;
{
    NSParameterAssert([rowIndexes count] == 1);
    if ([rowIndexes count] != 1)
        return NO;
    
    if (![self.operationQueue isSuspended])
        return NO;
    
    [pboard declareTypes:@[ OperationType ] owner:self];
    
    Operation *operation = self.operationQueue.operations[[rowIndexes firstIndex]];
    NSArray *names = @[ self.operationQueue.name, operation.name ];
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:names] forType:(NSString *)OperationType];
    
    return YES;
}

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector;
{
    if (control != self.operationNameField)
        return NO;
    
    if (commandSelector != @selector(insertNewline:))
        return NO;
    
    [self addOperation:control];
    return YES;
}

#pragma mark - Private

- (NSString *)_cellIdentifierForColumn:(OperationTableViewColumn)column;
{
    switch (column) {
        case OperationTableViewColumnDependencies: return @"dependenciesCell";
        case OperationTableViewColumnTime: return @"timeCell";
        case OperationTableViewColumnState: return @"stateCell";
        case OperationTableViewColumnName: return @"nameCell";
        case OperationTableViewColumnCancel: return @"cancelCell";
    }
}

- (NSArray *)_observedOperationKeyPaths;
{
    return @[ @"isCancelled", @"isExecuting", @"isFinished", @"isReady", @"dependencies" ];
}

#pragma mark Display helpers

- (NSString *)_nameForNewOperation;
{
    self.autogeneratedOperationIndex ++;
    return [NSString stringWithFormat:@"%@ %tu", self.operationQueue.name, self.autogeneratedOperationIndex];
}

- (NSString *)_displayStringForStateForOperation:(NSOperation *)operation;
{
    if ([operation isCancelled]) {
        return NSLocalizedString(@"Cancelled", @"cancelled state");
    } else if ([operation isFinished]) {
        return NSLocalizedString(@"Finished", @"finished state");
    } else if ([operation isExecuting]) {
        return NSLocalizedString(@"Executing", @"executing state");
    } else if ([operation isReady]) {
        return NSLocalizedString(@"Ready", @"ready state");
    } else {
        return NSLocalizedString(@"Waiting", @"waiting state");
    }
}

- (NSString *)_displayStringForDependenciesForOperation:(NSOperation *)operation;
{
    NSMutableArray *names = [NSMutableArray array];
    for (NSOperation *dependency in operation.dependencies) {
        if ([dependency isKindOfClass:[Operation class]]) {
            [names addObject:[(Operation *)dependency name]];
        } else {
            [names addObject:[NSString stringWithFormat:@"<%p>", dependency]];
        }
    }
    return [names componentsJoinedByString:@", "];
}

#pragma mark Drag & drop

- (Operation *)_operationFromDragInfo:(id<NSDraggingInfo>)info;
{
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSData *data = [pasteboard dataForType:(NSString *)OperationType];
    NSArray *names = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSAssert([names isKindOfClass:[NSArray class]], @"Expected an array of names from the pasteboard");
    NSAssert([names count] == 2, @"Expected a queue name and an operation name from the pasteboard");
    for (NSString *name in names) {
        NSAssert([name isKindOfClass:[NSString class]], @"Expected name from the pasteboard to be a string");
    }
    
    if (![self.delegate respondsToSelector:@selector(operationController:operationNamed:inQueueNamed:)])
        return nil;
    
    return [self.delegate operationController:self operationNamed:names[1] inQueueNamed:names[0]];
}

- (BOOL)_operation:(NSOperation *)operation isDependentOn:(NSOperation *)potentialDependency;
{
    if (operation == potentialDependency)
        return YES;
    
    for (NSOperation *dependency in operation.dependencies) {
        if ([self _operation:dependency isDependentOn:potentialDependency])
            return YES;
    }
    
    return NO;
}

@end
