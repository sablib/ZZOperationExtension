//
//  ZZOperationConditionResult.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZOperationConditionResultType) {
    ZZOperationConditionResultError,
    ZZOperationConditionResultSatisfied,
};

@interface ZZOperationConditionResult : NSObject

@property (nonatomic, assign) ZZOperationConditionResultType type;

@property (nonatomic, strong) NSError *error;

+ (instancetype)satisfiedResult;

+ (instancetype)resultWithError:(NSError *)error;

@end
