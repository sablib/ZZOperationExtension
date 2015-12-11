//
//  ZZObjectivePostlyExclusive.m
//  ZZOperationExtension
//
//  Created by sablib on 15/12/11.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZObjectivePostlyExclusive.h"
#import "ZZOperationConditionResult.h"

@interface ZZObjectivePostlyExclusive ()

@property (nonatomic, strong) id<ZZObjectivePostlyExclusiveIdentifier> object;

@end

@implementation ZZObjectivePostlyExclusive

- (instancetype)initWithObject:(id<ZZObjectivePostlyExclusiveIdentifier>)object {
    if (self = [super init]) {
        self.object = object;
    }
    return self;
}

- (instancetype)initWithClass:(Class)clazz {
    NSAssert(NO, @"This method should not be used. Use initWithObject instead.");
    return nil;
}

- (NSString *)name {
    return [NSString stringWithFormat:@"PostlyExclusive<%@>", [self.object identifier]];
}

@end
