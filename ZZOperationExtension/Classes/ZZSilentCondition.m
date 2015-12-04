//
//  ZZSilentCondition.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/26.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZSilentCondition.h"

@implementation ZZSilentCondition

- (instancetype)initWithCondition:(id<ZZOperationCondition>)condition {
    if (self = [super init]) {
        self.condition = condition;
    }
    return self;
}

- (NSString *)name {
    return [NSString stringWithFormat:@"Silent<%@>", self.condition.name];
}

- (BOOL)isMutuallyExclusive {
    return [self.condition isMutuallyExclusive];
}

- (NSOperation *)dependencyForOperation:(ZZOperation *)operation {
    return nil;
}

- (void)evalueteForOperation:(ZZOperation *)operation completion:(void (^)(ZZOperationConditionResult *))completion {
    [self.condition evalueteForOperation:operation completion:completion];
}

@end
