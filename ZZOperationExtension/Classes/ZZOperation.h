//
//  ZZOperation.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  state1 & state2 如果不为0即能够转换
 */
//typedef NS_ENUM(NSInteger, ZZOperationState) {
//    ZZOperationStateInitialized = 1,
//    ZZOperationStatePending = 7,
//    ZZOperationStateEvaluatingConditions = 6,
//    ZZOperationStateReady = 12,
//    ZZOperationStateExecuting = 24,
//    ZZOperationStateFinishing = 56,
//    ZZOperationStateFinished = 96
//};

@protocol ZZOperationCondition;
@protocol ZZOperationObserver;

@interface ZZOperation : NSOperation

@property (nonatomic, readonly) NSArray<id<ZZOperationCondition>> *conditions;

- (void)willEnqueue;
- (void)execute;
- (void)finish;
- (void)finishWithErrors:(NSArray<NSError *> *)errors;
- (void)cancelWithError:(NSError *)error;

- (void)addCondition:(id<ZZOperationCondition>)condition;
- (void)addObserver:(id<ZZOperationObserver>)observer;
- (void)addDependency:(NSOperation *)op;

- (void)produceOperation:(NSOperation *)operation;

@end
