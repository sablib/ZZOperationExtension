//
//  ZZObjectiveKeepFirstExclusive.m
//  ZZOperationExtension
//
//  Created by sablib on 16/1/6.
//  Copyright © 2016年 sablib. All rights reserved.
//

#import "ZZObjectiveKeepFirstExclusive.h"

@interface ZZObjectiveKeepFirstExclusive ()

@property (nonatomic, strong) id<ZZObjectiveExclusiveIdentifier> object;

@end

@implementation ZZObjectiveKeepFirstExclusive

- (instancetype)initWithObject:(id<ZZObjectiveExclusiveIdentifier>)object {
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
    return [NSString stringWithFormat:@"KeepFirstExclusive<%@>", [self.object zz_identifier]];
}

@end
