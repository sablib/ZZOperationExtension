//
//  NSError+OperationErrors.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZOperationErrorCode) {
    ZZOperationErrorConditionFailed = 1,
    ZZOperationErrorExecutionFailed = 2,
};


@interface NSError (ZZOperationErrors)

+ (instancetype)zz_errorWithCode:(ZZOperationErrorCode)code;

@end
