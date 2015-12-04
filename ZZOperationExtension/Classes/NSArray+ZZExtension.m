//
//  NSArray+Extension.m
//  aaa
//
//  Created by 张凯 on 15/10/21.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "NSArray+ZZExtension.h"

@implementation NSArray (ZZExtension)


-(instancetype)zz_map:(ZZMapBlock)block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [result addObject:block(obj)];
    }
    return result.copy;
}

- (instancetype)zz_filter:(ZZFilterBlock)block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }
    return result.copy;
}

- (instancetype)zz_arrayByRemoveObjectAtIndex:(NSUInteger)index {
    NSMutableArray *array = self.mutableCopy;
    [array removeObjectAtIndex:index];
    return array.copy;
}

@end
