//
//  ZZTimeoutObserver.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZTimeoutObserver.h"
#import "ZZOperation.h"
#import "NSError+ZZOperationErrors.h"

static NSString *timeoutKey = @"ZZOperationTimeout";

@interface ZZTimeoutObserver ()

@property (nonatomic, assign) NSTimeInterval timeout;

@end

@implementation ZZTimeoutObserver

- (instancetype)initWithTimeoutInterval:(NSTimeInterval)interval {
    if (self = [super init]) {
        self.timeout = interval;
    }
    return self;
}

- (void)operationDidStart:(ZZOperation *)operation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!operation.finished && !operation.cancelled) {
            NSError *error = [NSError zz_errorWithCode:ZZOperationErrorConditionFailed];
            [operation cancelWithError:error];
        }
    });
}

- (void)operation:(ZZOperation *)operation didProduceOperation:(NSOperation *)newOperation {
    
}

- (void)operationDidFinished:(ZZOperation *)operation withErrors:(NSArray<NSError *> *)errors {
    
}

@end
