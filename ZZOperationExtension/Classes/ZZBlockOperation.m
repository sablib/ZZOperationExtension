//
//  ZZBlockOperation.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZBlockOperation.h"

@interface ZZBlockOperation ()

@property (nonatomic, strong) ZZOperationBlock block;

@end

@implementation ZZBlockOperation

- (instancetype)initWithBlock:(ZZOperationBlock)block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (instancetype)initWithMainQueueBlock:(dispatch_block_t)block {
    return [self initWithBlock:^(dispatch_block_t continuation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
            continuation();
        });
    }];
}

- (void)execute {
    if (self.block) {
        self.block(^{
            [self finish];
        });
    } else {
        [self finish];
    }
}

@end
