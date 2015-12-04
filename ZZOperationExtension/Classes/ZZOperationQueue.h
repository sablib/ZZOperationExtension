//
//  ZZOperationQueue.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZOperationQueue;

@protocol ZZOperationQueueDelegate <NSObject>

- (void)operationQueue:(ZZOperationQueue *)queue
      willAddOperation:(NSOperation *)operation;
- (void)operationQueue:(ZZOperationQueue *)queue
    operationDidFinish:(NSOperation *)operation
                withErrors:(NSArray<NSError *> *)errors;

@end

@interface ZZOperationQueue : NSOperationQueue

@property (nonatomic, weak) id<ZZOperationQueueDelegate> delegate;

@end
