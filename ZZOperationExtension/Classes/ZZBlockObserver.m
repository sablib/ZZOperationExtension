//
//  BlockObserver.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZBlockObserver.h"
#import "ZZOperation.h"

@interface ZZBlockObserver ()

@property (nonatomic, strong) void (^startHandler)(ZZOperation *operation);
@property (nonatomic, strong) void (^produceHandler)(ZZOperation *operation, NSOperation *newOperation);
@property (nonatomic, strong) void (^finishHandler)(ZZOperation *operation, NSArray<NSError *> *errors);

@end

@implementation ZZBlockObserver

- (instancetype)initWithStartHandler:(void(^)(ZZOperation *operation))startHandler
                      produceHandler:(void(^)(ZZOperation *operation, NSOperation *newOperation))produceHandler
                       finishHandler:(void(^)(ZZOperation *operation, NSArray<NSError *> *errors))finishandler {
    if (self = [super init]) {
        self.startHandler = startHandler;
        self.produceHandler = produceHandler;
        self.finishHandler = finishandler;
    }
    return self;
}

- (instancetype)initWithFinishHandler:(void (^)(ZZOperation *, NSArray<NSError *> *))finishandler {
    return [self initWithStartHandler:nil
                       produceHandler:nil
                        finishHandler:finishandler];
}

- (void)operationDidStart:(ZZOperation *)operation {
    !self.startHandler ?: self.startHandler(operation);
}

- (void)operation:(ZZOperation *)operation didProduceOperation:(NSOperation *)newOperation {
    !self.produceHandler ?: self.produceHandler(operation, newOperation);
}

- (void)operationDidFinished:(ZZOperation *)operation withErrors:(NSArray<NSError *> *)errors {
    !self.finishHandler ?: self.finishHandler(operation, errors);
}

@end
