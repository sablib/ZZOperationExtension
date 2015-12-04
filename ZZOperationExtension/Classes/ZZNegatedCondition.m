//
//  ZZNegatedCondition.m
//  aaa
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZNegatedCondition.h"
#import "ZZOperationConditionResult.h"
#import "NSError+ZZOperationErrors.h"

@implementation ZZNegatedCondition

- (instancetype)initWithCondition:(id<ZZOperationCondition>)condition {
    if (self = [super init]) {
        self.condition = condition;
    }
    return self;
}

- (NSString *)name {
    return @"ZZNegatedCondition";
}

- (NSOperation *)dependencyForOperation:(ZZOperation *)operation {
    return [self.condition dependencyForOperation:operation];
}

- (BOOL)isMutuallyExclusive {
    return ![self.condition isMutuallyExclusive];
}

- (void)evalueteForOperation:(ZZOperation *)operation completion:(void (^)(ZZOperationConditionResult *result))completion {
    [self.condition evalueteForOperation:operation completion:^(ZZOperationConditionResult *result) {
        if (result.type == ZZOperationConditionResultSatisfied) {
            NSError *error = [NSError zz_errorWithCode:ZZOperationErrorConditionFailed];
            completion([ZZOperationConditionResult resultWithError:error]);
        } else {
            completion([ZZOperationConditionResult satisfiedResult]);
        }
    }];
}

@end
