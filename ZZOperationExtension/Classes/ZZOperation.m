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

@end

@implementation ZZOperation

@synthesize state = _state;

@dynamic ready;
@dynamic finished;
@dynamic executing;

+ (dispatch_queue_t)sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("ZZOperation.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

+ (NSSet *)keyPathsForValuesAffectingIsReady {
    return [NSSet setWithObjects:@"state", nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished {
    return [NSSet setWithObjects:@"state", nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsExecuting {
    return [NSSet setWithObjects:@"state", nil];
}

- (instancetype)init {
    if (self = [super init]) {
        _state = ZZOperationStateInitialized;
        self.stateLock = [[NSLock alloc] init];
        self.conditions = @[].mutableCopy;
        self.observers = @[].mutableCopy;
        self.internalErrors = @[].mutableCopy;
        self.hasFinishedAlready = NO;
    }
    return self;
}

- (BOOL)isReady {
    switch (self.state) {
        case ZZOperationStateInitialized:
            return self.cancelled;
        case ZZOperationStatePending:
            if (self.isCancelled) {
                return YES;
            } else if (self.conditions.count == 0) {
                self.state = ZZOperationStateReady;
                return YES;
            } else if ([super isReady]) {
                [self evaluateConditions];
            }
            return NO;
        case ZZOperationStateReady:
            return super.isReady || self.cancelled;
        default:
            return NO;
    }
}

- (BOOL)isExecuting {
    return self.state == ZZOperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == ZZOperationStateFinished;
}

- (void)evaluateConditions {
    if (self.isCancelled) {
        self.state = ZZOperationStateReady;
        return;
    }
    
    NSAssert(self.state == ZZOperationStatePending, @"evaluateConditions was called out-of-order");
    
    self.state = ZZOperationStateEvaluatingConditions;
    [ZZOperationConditionEvaluator evaluateWithConditions:self.conditions operation:self completion:^(NSArray<NSError *> *failures) {
        [self.internalErrors addObjectsFromArray:failures];
        self.state = ZZOperationStateReady;
    }];
}

- (void)addCondition:(id<ZZOperationCondition>)condition {
    NSAssert(self.state < ZZOperationStateEvaluatingConditions, @"cannot add condition after evaluatingConditions");
    
    [self.conditions addObject:condition];
}

- (void)addObserver:(id<ZZOperationObserver>)observer {
    NSAssert(self.state < ZZOperationStateExecuting, @"cannot add observer after execute");
    
    [self.observers addObject:observer];
}

- (void)addDependency:(NSOperation *)op {
    NSAssert(self.state < ZZOperationStateExecuting, @"cannot add dependency after execute");
    
    [super addDependency:op];
}

- (void)willEnqueue {
    self.state = ZZOperationStatePending;
}

- (void)main {
    NSAssert(self.state == ZZOperationStateReady, @"This operation must be performed on a operation queue");
    
    if (self.internalErrors.count == 0 && !self.isCancelled) {
        self.state = ZZOperationStateExecuting;
        
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
            self.state = ZZOperationStateFinishing;
            
            NSArray<NSError *> *combinedErrors = [self.internalErrors.copy arrayByAddingObjectsFromArray:errors];
            [self finished:combinedErrors];
            
            for (id<ZZOperationObserver> observer in self.observers) {
                [observer operationDidFinished:self withErrors:combinedErrors];
            }
            self.state = ZZOperationStateFinished;
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

- (ZZOperationState)state {
    return [[self.stateLock withCriticalScope:^id{
        return @(_state);
    }] integerValue];
}

- (void)setState:(ZZOperationState)state {
    if (_state != state) {
        [self willChangeValueForKey:@"state"];
        [self.stateLock withCriticalScope:^id{
            NSAssert(_state & state || (_state == ZZOperationStatePending && state == ZZOperationStateReady && self.conditions.count == 0) || state == ZZOperationStateFinishing, @"perform invalid state transition");
            _state = state;
            return nil;
        }];
        [self didChangeValueForKey:@"state"];
    }
}

@end
