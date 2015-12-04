//
//  ZZGroupOperation.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZGroupOperation.h"

@interface ZZGroupOperation ()

@property (nonatomic, strong) ZZOperationQueue *internalQueue;
@property (nonatomic, strong) NSBlockOperation *startingOperation;
@property (nonatomic, strong) NSBlockOperation *finishingOperation;

@property (nonatomic, strong) NSArray<NSError *> *aggregatedErrors;

@end

@implementation ZZGroupOperation

- (instancetype)init {
    if (self = [super init]) {
        self.internalQueue = [[ZZOperationQueue alloc] init];
        self.startingOperation = [NSBlockOperation blockOperationWithBlock:^{}];
        self.finishingOperation = [NSBlockOperation blockOperationWithBlock:^{}];
        self.aggregatedErrors = @[];
    }
    return self;
}

- (instancetype)initWithOperations:(NSArray<NSOperation *> *)operations {
    if (self = [self init]) {
        self.internalQueue.suspended = YES;
        self.internalQueue.delegate = self;
        [self.internalQueue addOperation:self.startingOperation];
        for (NSOperation *op in operations) {
            [self.internalQueue addOperation:op];
        }
    }
    return self;
}

- (void)cancel {
    [self.internalQueue cancelAllOperations];
    [super cancel];
}

- (void)execute {
    self.internalQueue.suspended = NO;
    [self.internalQueue addOperation:self.finishingOperation];
}

- (void)aggregateError:(NSError *)error {
    self.aggregatedErrors = [self.aggregatedErrors arrayByAddingObject:error];
}

- (void)addOperation:(NSOperation *)operation {
    [self.internalQueue addOperation:operation];
}

- (void)operation:(NSOperation *)operation didFinishedWithErrors:(NSArray<NSError *> *)errors {
    //FOR SUBCLASS
}

- (void)operationQueue:(ZZOperationQueue *)queue operationDidFinish:(NSOperation *)operation withErrors:(NSArray<NSError *> *)errors {
    self.aggregatedErrors = [self.aggregatedErrors arrayByAddingObjectsFromArray:errors];
    
    if (operation == self.finishingOperation) {
        self.internalQueue.suspended = YES;
        [self finishWithErrors:self.aggregatedErrors];
    } else if (operation != self.startingOperation) {
        [self operation:operation didFinishedWithErrors:errors];
    }
}

- (void)operationQueue:(ZZOperationQueue *)queue willAddOperation:(NSOperation *)operation {
    NSAssert(!self.finishingOperation.finished && !self.finishingOperation.executing, @"cannot add operation to group after froup has completed.");
    
    if (operation != self.finishingOperation) {
        [self.finishingOperation addDependency:operation];
    }
    
    if (operation != self.startingOperation) {
        [operation addDependency:self.startingOperation];
    }
}

@end
