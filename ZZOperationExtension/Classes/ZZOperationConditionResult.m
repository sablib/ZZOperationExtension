//
//  ZZOperationConditionResult.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperationConditionResult.h"

@implementation ZZOperationConditionResult

+ (instancetype)satisfiedResult {
    ZZOperationConditionResult *result = [[ZZOperationConditionResult alloc] init];
    result.type = ZZOperationConditionResultSatisfied;
    return result;
}

+ (instancetype)resultWithError:(NSError *)error {
    if (error) {
        ZZOperationConditionResult *result = [[ZZOperationConditionResult alloc] init];
        result.type = ZZOperationConditionResultError;
        result.error = error;
        return result;
    } else {
        return nil;
    }
}

@end
