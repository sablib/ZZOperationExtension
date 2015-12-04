//
//  ZZNoCancelledDependencies.m
//  ZZOperationExtension
//
//  Created by sablib on 15/12/2.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZNoCancelledDependencies.h"
#import "ZZOperation.h"
#import "ZZOperationConditionResult.h"
#import "NSError+ZZOperationErrors.h"
#import "NSArray+ZZExtension.h"

@implementation ZZNoCancelledDependencies

- (NSString *)name {
    return NSStringFromClass([self class]);
}

- (BOOL)isMutuallyExclusive {
    return NO;
}

- (NSOperation *)dependencyForOperation:(ZZOperation *)operation {
    return nil;
}

- (void)evalueteForOperation:(ZZOperation *)operation completion:(void (^)(ZZOperationConditionResult *))completion {
    NSArray *cancelled = [operation.dependencies zz_filter:^BOOL(NSOperation *each) {
        return each.isCancelled;
    }];
    
    if (cancelled.count > 0) {
        completion([ZZOperationConditionResult resultWithError:[NSError zz_errorWithCode:ZZOperationErrorConditionFailed]]);
    } else {
        completion([ZZOperationConditionResult satisfiedResult]);
    }
}

@end
