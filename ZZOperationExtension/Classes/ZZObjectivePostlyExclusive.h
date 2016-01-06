//
//  ZZObjectivePostlyExclusive.h
//  ZZOperationExtension
//
//  Created by sablib on 15/12/11.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZPostlyExclusive.h"
#import "ZZObjectiveExclusiveIdentifier.h"

@interface ZZObjectivePostlyExclusive : ZZPostlyExclusive

- (instancetype)initWithObject:(id<ZZObjectiveExclusiveIdentifier>)object;

@end
