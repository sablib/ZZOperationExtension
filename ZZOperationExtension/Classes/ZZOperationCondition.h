//
//  ZZOperationCondition.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZOperation;
@class ZZOperationConditionResult;

@protocol ZZOperationCondition <NSObject>

- (NSString *)name;
- (BOOL)isMutuallyExclusive;

- (NSOperation *)dependencyForOperation:(ZZOperation *)operation;
- (void)evalueteForOperation:(ZZOperation *)operation
                  completion:(void (^)(ZZOperationConditionResult *result))completion;

@end
