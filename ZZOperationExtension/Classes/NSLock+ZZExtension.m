//
//  NSLock+Extension.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "NSLock+ZZExtension.h"

@implementation NSLock (ZZExtension)

- (id)withCriticalScope:(id(^)(void))block
{
    [self lock];
    id value = block();
    [self unlock];
    return value;
}

@end
