//
//  ZZBlockOperation.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZOperation.h"

typedef void(^ZZOperationBlock)(dispatch_block_t);


@interface ZZBlockOperation : ZZOperation

- (instancetype)initWithBlock:(ZZOperationBlock)block;
- (instancetype)initWithMainQueueBlock:(dispatch_block_t)block;

@end
