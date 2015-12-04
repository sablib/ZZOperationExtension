//
//  ZZURLSessionTaskOperation.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZURLSessionTaskOperation.h"

static char ZZURLSessionTaskKVOContext = 0;

@implementation ZZURLSessionTaskOperation

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    if (self = [super init]) {
        NSAssert(task.state == NSURLSessionTaskStateSuspended, @"task must be suspended");
        self.task = task;
    }
    return self;
}

- (void)execute {
    NSAssert(self.task.state == NSURLSessionTaskStateSuspended, @"task was sumed by something other than self");
    
    [self.task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:&ZZURLSessionTaskKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context != &ZZURLSessionTaskKVOContext) { return; }
    if ([keyPath isEqualToString:@"state"] && object == self.task && self.task.state == NSURLSessionTaskStateCompleted) {
        [self.task removeObserver:self forKeyPath:@"state"];
        [self finish];
    }
}

- (void)cancel {
    [self.task cancel];
    [super cancel];
}

@end
