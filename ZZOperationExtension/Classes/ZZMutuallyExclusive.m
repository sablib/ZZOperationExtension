//
//  ZZMutuallyExclusive.m
//  aaa
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZMutuallyExclusive.h"
#import "ZZOperationConditionResult.h"

@interface ZZMutuallyExclusive ()

@end

@implementation ZZMutuallyExclusive

- (instancetype)initWithClass:(Class)clazz {
    if (self = [super init]) {
        self.clazz = clazz;
    }
    return self;
}

+ (instancetype)exclusiveWithClass:(Class)clazz {
    return [[self alloc] initWithClass:clazz];
}

- (NSString *)name {
    return [NSString stringWithFormat:@"MutuallyExclusive<%@>", NSStringFromClass(self.clazz)];
}

- (BOOL)isMutuallyExclusive {
    return YES;
}


- (NSOperation *)dependencyForOperation:(ZZOperation *)operation {
    return nil;
}

- (void)evalueteForOperation:(ZZOperation *)operation completion:(void (^)(ZZOperationConditionResult *))completion {
    completion([ZZOperationConditionResult satisfiedResult]);
}

@end
