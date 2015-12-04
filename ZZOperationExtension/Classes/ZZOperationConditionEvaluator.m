//
//  ZZOperationConditionEvaluator.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperationConditionEvaluator.h"
#import "ZZOperation.h"
#import "ZZOperationConditionResult.h"
#import "ZZOperationCondition.h"
#import "NSArray+ZZExtension.h"
#import "NSError+ZZOperationErrors.h"

@implementation ZZOperationConditionEvaluator

+ (void)evaluateWithConditions:(NSArray *)conditions
                     operation:(ZZOperation *)operation
                    completion:(void (^)(NSArray<NSError *> *))completion {
    dispatch_group_t conditionGroup = dispatch_group_create();
    __block NSMutableArray<ZZOperationConditionResult *> *results = [NSMutableArray arrayWithCapacity:conditions.count];
    [conditions enumerateObjectsUsingBlock:^(id<ZZOperationCondition> condition, NSUInteger idx, BOOL *stop) {
        dispatch_group_enter(conditionGroup);
        [condition evalueteForOperation:operation completion:^(ZZOperationConditionResult *result) {
            results[idx] = result;
            dispatch_group_leave(conditionGroup);
        }];
    }];
    
    dispatch_group_notify(conditionGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<NSError *> *failures = [[results zz_filter:^BOOL(ZZOperationConditionResult *each) {
            return each.type == ZZOperationConditionResultError && each.error;
        }] zz_map:^NSError *(ZZOperationConditionResult *each) {
            return each.error;
        }].mutableCopy;
        
        if (operation.isCancelled) {
            [failures addObject:[NSError zz_errorWithCode:ZZOperationErrorConditionFailed]];
        }
        
        completion(failures);
    });
}

@end
