//
//  ZZDelayOperation.h
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperation.h"

typedef NS_ENUM(NSInteger, ZZDelayOperationType) {
    ZZDelayOperationTypeTimeInterval,
    ZZDelayOperationTypeNSDate,
};

@interface ZZDelayOperation : ZZOperation

- (instancetype)initWithInterval:(NSTimeInterval)interval;
- (instancetype)initWithDate:(NSDate *)date;

@end
