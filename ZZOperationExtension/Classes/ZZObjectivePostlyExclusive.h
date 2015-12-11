//
//  ZZObjectivePostlyExclusive.h
//  ZZOperationExtension
//
//  Created by sablib on 15/12/11.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZPostlyExclusive.h"

@protocol ZZObjectivePostlyExclusiveIdentifier <NSObject>

- (NSString *)identifier;

@end

@interface ZZObjectivePostlyExclusive : ZZPostlyExclusive

- (instancetype)initWithObject:(id<ZZObjectivePostlyExclusiveIdentifier>)object;

@end
