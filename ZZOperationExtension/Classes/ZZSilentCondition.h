//
//  ZZSilentCondition.h
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/26.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZOperationCondition.h"

@interface ZZSilentCondition : NSObject <ZZOperationCondition>

@property (nonatomic, strong) id<ZZOperationCondition> condition;

- (instancetype)initWithCondition:(id<ZZOperationCondition>)condition;

@end
