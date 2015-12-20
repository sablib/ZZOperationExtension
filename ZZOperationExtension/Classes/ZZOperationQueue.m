//
//  ZZOperationQueue.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperationQueue.h"
#import "ZZOperation.h"
#import "ZZBlockObserver.h"
#import "NSOperation+ZZExtension.h"
#import "NSArray+ZZExtension.h"
#import "ZZOperationCondition.h"
#import "ZZExclusivityController.h"

@implementation ZZOperationQueue

- (void)addOperation:(NSOperation *)op {
    __weak typeof(self) __weak_self = self;
    
    if ([op isKindOfClass:[ZZOperation class]]) {
        ZZOperation *operation = (ZZOperation *)op;
        
        id<ZZOperationObserver> delegate = [[ZZBlockObserver alloc] initWithStartHandler:nil produceHandler:^(ZZOperation *operation, NSOperation *newOperation) {
            [__weak_self addOperation:operation];
        } finishHandler:^(ZZOperation *operation, NSArray<NSError *> *errors) {
            if (__weak_self.delegate) {
                [__weak_self.delegate operationQueue:__weak_self operationDidFinish:operation withErrors:errors];
            }
        }];
        [operation addObserver:delegate];
        
        NSArray *dependencies = [[operation.conditions zz_filter:^BOOL(id<ZZOperationCondition> each) {
            return [each dependencyForOperation:operation] != nil;
        }] zz_map:^id(id<ZZOperationCondition> each) {
            return [each dependencyForOperation:operation];
        }];
        
        for (NSOperation *dependency in dependencies) {
            [operation addDependency:dependency];
            [self addOperation:dependency];
        }
        
        NSArray<NSString *> *concurrencyCateGories = (NSArray<NSString *> *)[[operation.conditions zz_filter:^BOOL(id<ZZOperationCondition> each) {
            return [each isMutuallyExclusive];
        }] zz_map:^NSString *(id<ZZOperationCondition> each) {
            return [each name];
        }];
        
        if (concurrencyCateGories.count > 0) {
            ZZExclusivityController *exclusivityController = [ZZExclusivityController sharedExclusivityController];
            [exclusivityController addOperation:operation withCategories:concurrencyCateGories];
            
            [operation addObserver:[[ZZBlockObserver alloc] initWithFinishHandler:^(ZZOperation *operation, NSArray<NSError *> *errors) {
                [exclusivityController removeOperation:operation withCategories:concurrencyCateGories];
            }]];
        }
        
        [operation willEnqueue];
        
    } else {
        __weak NSOperation *__weak_operaton = op;
        [op zz_addCompletionBlock:^{
            if (__weak_self == nil || __weak_operaton == nil) {
                return;
            }
            
            if ([__weak_self.delegate respondsToSelector:@selector(operationQueue:operationDidFinish:withErrors:)]) {
                [__weak_self.delegate operationQueue:__weak_self operationDidFinish:__weak_operaton withErrors:nil];
            }
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(operationQueue:willAddOperation:)]) {
        [self.delegate operationQueue:self willAddOperation:op];
    }
    
    if (self.isSerial) {
        NSOperation *lastOperationInQueue = self.operations.lastObject;
        if (lastOperationInQueue) {
            [op addDependency:lastOperationInQueue];
        }
    }
    [super addOperation:op];
}

@end
