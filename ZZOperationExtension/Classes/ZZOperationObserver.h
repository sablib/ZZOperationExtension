//
//  ZZOperationObserver.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZOperation;

@protocol ZZOperationObserver <NSObject>

- (void)operationDidStart:(ZZOperation *)operation;
- (void)operation:(ZZOperation *)operation didProduceOperation:(NSOperation *)newOperation;
- (void)operationDidFinished:(ZZOperation *)operation withErrors:(NSArray<NSError *> *)errors;

@end
