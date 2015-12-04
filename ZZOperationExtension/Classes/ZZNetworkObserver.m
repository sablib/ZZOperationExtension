//
//  ZZNetworkObserver.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZNetworkObserver.h"
#import "ZZNetworkIndicatorController.h"

@implementation ZZNetworkObserver

- (void)operationDidStart:(ZZOperation *)operation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZZNetworkIndicatorController sharedIndicatorController] networkActivityDidStart];
    });
}

- (void)operationDidFinished:(ZZOperation *)operation withErrors:(NSArray<NSError *> *)errors {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZZNetworkIndicatorController sharedIndicatorController] networkActivityDidEnd];
    });
}

- (void)operation:(ZZOperation *)operation didProduceOperation:(NSOperation *)newOperation {
    ;
}

@end
