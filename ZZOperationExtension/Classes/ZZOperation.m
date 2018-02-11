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

@property (nonatomic, strong, readwrite) NSArray<id<ZZOperationCondition>> *conditions;
@property (nonatomic, strong) NSMutableArray<id<ZZOperationObserver>> *observers;

@property (nonatomic, strong) NSArray<NSError *> *internalErrors;

@property (nonatomic, assign) BOOL hasFinishedAlready;
@property (nonatomic, assign) BOOL hasFinishEvaluatingCondtions;

@property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;

@end

@implementation ZZOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

+ (NSSet *)keyPathsForValuesAffectingIsReady {
    return [NSSet setWithObjects:@"hasFinishEvaluatingCondtions", nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished {
    return [NSSet setWithObjects:@"finished", nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsExecuting {
    return [NSSet setWithObjects:@"executing", nil];
}

- (void)setHasFinishedAlready:(BOOL)hasFinishedAlready {
    [self willChangeValueForKey:@"hasFinishedAlready"];
    _hasFinishedAlready = hasFinishedAlready;
    [self didChangeValueForKey:@"hasFinishedAlready"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"executing"];
    _executing = executing;
    [self didChangeValueForKey:@"executing"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"finished"];
    _finished = finished;
    [self didChangeValueForKey:@"finished"];
}


- (instancetype)init {
    if (self = [super init]) {
        _conditions = @[].mutableCopy;
        _observers = @[].mutableCopy;
        _internalErrors = @[];
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
            self.internalErrors = [self.internalErrors arrayByAddingObjectsFromArray:failures];
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
    
    self.conditions = [self.conditions arrayByAddingObject:condition];
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
    if (!self.hasFinishedAlready) {
        self.hasFinishedAlready = YES;
        
        NSArray<NSError *> *combinedErrors = [self.internalErrors arrayByAddingObjectsFromArray:errors];
        [self finished:combinedErrors];
        
        for (id<ZZOperationObserver> observer in self.observers) {
            [observer operationDidFinished:self withErrors:combinedErrors];
        }
        
        self.executing = NO;
        self.finished = YES;
    }
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
        self.internalErrors = [self.internalErrors arrayByAddingObject:error];
    }
    [self cancel];
}

- (void)produceOperation:(NSOperation *)operation {
    for (id<ZZOperationObserver> observer in self.observers) {
        [observer operation:self didProduceOperation:operation];
    }
}

@end
