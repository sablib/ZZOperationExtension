//
//  NSOperation+Extension.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "NSOperation+ZZExtension.h"

@implementation NSOperation (ZZExtension)

- (void)zz_addCompletionBlock:(dispatch_block_t)block {
    if (self.completionBlock) {
        __weak typeof(self) __weak_self = self;
        self.completionBlock = ^{
            __weak_self.completionBlock();
            block();
        };
    } else {
        self.completionBlock = block;
    }
}

- (void)zz_addDependencies:(NSArray<NSOperation *> *)dependencies {
    for (NSOperation *operation in dependencies) {
        [self addDependency:operation];
    }
}

@end
