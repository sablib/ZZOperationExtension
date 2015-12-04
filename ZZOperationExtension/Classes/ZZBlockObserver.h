//
//  BlockObserver.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZOperationObserver.h"

@interface ZZBlockObserver : NSObject <ZZOperationObserver>

- (instancetype)initWithStartHandler:(void(^)(ZZOperation *operation))startHandler
                      produceHandler:(void(^)(ZZOperation *operation, NSOperation *newOperation))produceHandler
                       finishHandler:(void(^)(ZZOperation *operation, NSArray<NSError *> *errors))finishandler;

- (instancetype)initWithFinishHandler:(void (^)(ZZOperation *, NSArray<NSError *> *))finishandler;

@end
