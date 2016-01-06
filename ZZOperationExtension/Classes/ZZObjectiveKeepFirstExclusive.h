//
//  ZZObjectiveKeepFirstExclusive.h
//  ZZOperationExtension
//
//  Created by sablib on 16/1/6.
//  Copyright © 2016年 sablib. All rights reserved.
//

#import "ZZKeepFirstExclusive.h"
#import "ZZObjectiveExclusiveIdentifier.h"

@interface ZZObjectiveKeepFirstExclusive : ZZKeepFirstExclusive

- (instancetype)initWithObject:(id<ZZObjectiveExclusiveIdentifier>)object;

@end
