//
//  ZZOperationConditionEvaluator.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZOperation;

@interface ZZOperationConditionEvaluator : NSObject

+ (void)evaluateWithConditions:(NSArray *)conditions
                     operation:(ZZOperation *)operation
                    completion:(void (^)(NSArray<NSError *> *))completion;

@end
