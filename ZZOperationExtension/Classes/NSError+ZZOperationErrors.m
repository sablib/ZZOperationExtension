//
//  NSError+OperationErrors.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "NSError+ZZOperationErrors.h"

static NSString *kZZOperationErrorDomain = @"ZZOperationErrors";

@implementation NSError (ZZOperationErrors)

+ (instancetype)zz_errorWithCode:(ZZOperationErrorCode)code {
    return [self errorWithDomain:kZZOperationErrorDomain code:code userInfo:nil];
}

@end
