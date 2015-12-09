//
//  ZZGroupOperation.h
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperation.h"
#import "ZZOperationQueue.h"

@interface ZZGroupOperation : ZZOperation <ZZOperationQueueDelegate>

@property (nonatomic, assign) BOOL isSerial;

- (instancetype)initWithOperations:(NSArray<NSOperation *> *)operations;
- (instancetype)initWithSerialOperations:(NSArray<NSOperation *> *)operations;

- (void)aggregateError:(NSError *)error;
- (void)operation:(NSOperation *)operation didFinishedWithErrors:(NSArray<NSError *> *)errors;

@end
