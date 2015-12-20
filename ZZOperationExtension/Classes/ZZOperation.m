//
//  ZZOperation.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperation.h"
#import "NSLock+ZZExtension.h"
#import "ZZOperationConditionEvaluator.h"
#import "ZZOperationCondition.h"
#import "ZZOperationObserver.h"

@interface ZZOperation ()

@property (nonatomic, strong) NSLock *stateLock;

@property (nonatomic, strong, readwrite) NSMutableArray<id<ZZOperationCondition>> *conditions;
@property (nonatomic, strong) NSMutableArray<id<ZZOperationObserver>> *observers;

@property (nonatomic, strong) NSMutableArray<NSError *> *internalErrors;

@property (nonatomic, assign) BOOL hasFinishedAlready;
@property (nonatomic, assign) BOOL hasFinishEvaluatingCondtions;

@property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;

@end

@implementation ZZOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

+ (dispatch_queue_t)sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("ZZOperation.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

+ (NSSet *)keyPathsForValuesAffectingIsReady {
    return [NSSet setWithObjects:@"state", @"hasFinishEvaluatingCondtions", nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished {
    return [NSSet setWithObjects:@"finished", nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsExecuting {
    return [NSSet setWithObjects:@"executing", nil];
}

- (instancetype)init {
    if (self = [super init]) {
        _conditions = @[].mutableCopy;
        _observers = @[].mutableCopy;
        _internalErrors = @[].mutableCopy;
        _hasFinishedAlready = NO;
        _hasFinishEvaluatingCondtions = NO;
    }
    return self;
}

- (BOOL)isReady {
    if (![super isReady]) {
        return self.isCancelled;
    } else if (self.hasFinishEvaluatingCondtions) {
        return YES;
    } else {
        return [self evaluateConditions];
    }
}

- (BOOL)evaluateConditions {
    if (self.isCancelled) {
        return YES;
    }
    
    if (self.conditions.count == 0) {
        self.hasFinishEvaluatingCondtions = YES;
    } else {
        [ZZOperationConditionEvaluator evaluateWithConditions:self.conditions operation:self completion:^(NSArray<NSError *> *failures) {
            [self.internalErrors addObjectsFromArray:failures];
            if (failures.count) {
                self.hasFinishEvaluatingCondtions = NO;
            } else {
                self.hasFinishEvaluatingCondtions = YES;
            }
        }];
    }
    return self.hasFinishEvaluatingCondtions;
}

- (void)addCondition:(id<ZZOperationCondition>)condition {
    NSAssert(self.hasFinishEvaluatingCondtions == NO, @"cannot add condition after evaluatingConditions");
    
    [self.conditions addObject:condition];
}

- (void)addObserver:(id<ZZOperationObserver>)observer {
    NSAssert(self.isExecuting == NO, @"cannot add observer after execute");
    
    [self.observers addObject:observer];
}

- (void)addDependency:(NSOperation *)op {
    NSAssert(self.isExecuting == NO, @"cannot add dependency after execute");
    
    [super addDependency:op];
}

- (void)willEnqueue {

}

- (void)main {
    if (self.internalErrors.count == 0 && !self.isCancelled) {
        self.executing = YES;
        
        for (id<ZZOperationObserver> observer in self.observers) {
            [observer operationDidStart:self];
        }
        
        [self execute];
    } else {
        [self finish];
    }
}

- (void)execute {
    NSLog(@"%@ must override execute() method.", NSStringFromClass([self class]));
    
    [self finish];
}

- (void)finish {
    [self finishWithErrors:@[]];
}

- (void)finishWithErrors:(NSArray<NSError *> *)errors {
    dispatch_async([ZZOperation sharedQueue], ^{
        if (!self.hasFinishedAlready) {
            self.hasFinishedAlready = YES;
            
            NSArray<NSError *> *combinedErrors = [self.internalErrors.copy arrayByAddingObjectsFromArray:errors];
            [self finished:combinedErrors];
            
            for (id<ZZOperationObserver> observer in self.observers) {
                [observer operationDidFinished:self withErrors:combinedErrors];
            }
            
            self.finished = YES;
        }
    });
}

- (void)finished:(NSArray<NSError *> *)errors {
    //for subclass to override
}

- (void)finishWithError:(NSError *)error {
    if (error) {
        [self finishWithErrors:@[error]];
    } else {
        [self finish];
    }
}

- (void)cancelWithError:(NSError *)error {
    if (error) {
        [self.internalErrors addObject:error];
    }
    [self cancel];
}

- (void)produceOperation:(NSOperation *)operation {
    for (id<ZZOperationObserver> observer in self.observers) {
        [observer operation:self didProduceOperation:operation];
    }
}

@end
