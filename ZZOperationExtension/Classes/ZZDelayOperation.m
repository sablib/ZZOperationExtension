//
//  ZZDelayOperation.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZDelayOperation.h"

@interface ZZDelayOperation ()

@property (nonatomic, assign) ZZDelayOperationType delayType;

@property (nonatomic, assign) NSTimeInterval delayedTimeInterval;
@property (nonatomic, strong) NSDate *delayedToDate;

@end

@implementation ZZDelayOperation

- (instancetype)initWithInterval:(NSTimeInterval)interval {
    if (self = [super init]) {
        self.delayType = ZZDelayOperationTypeTimeInterval;
        self.delayedTimeInterval = interval;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.delayType = ZZDelayOperationTypeNSDate;
        self.delayedToDate = date;
    }
    return self;
}

- (void)execute {
    NSTimeInterval interval = 0;
    if (self.delayType == ZZDelayOperationTypeTimeInterval) {
        interval = self.delayedTimeInterval;
    } else {
        interval = [self.delayedToDate timeIntervalSinceNow];
    }
    
    if (interval <= 0) {
        [self finish];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!self.isCancelled) {
            [self finish];
        }
    });
}

- (void)cancel {
    [super cancel];
    [self finish];
}

@end
