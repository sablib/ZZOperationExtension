//
//  ZZMutuallyExclusive.h
//  aaa
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZOperationCondition.h"

@interface ZZMutuallyExclusive : NSObject <ZZOperationCondition>

@property (nonatomic, copy) Class clazz;


- (instancetype)initWithClass:(Class)clazz;

+ (instancetype)exclusiveWithClass:(Class)clazz;

@end
