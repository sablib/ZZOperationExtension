//
//  ZZNetworkIndicatorController.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZNetworkIndicatorController.h"

@interface ZZNetworkIndicatorTimer : NSObject

@property (nonatomic, assign) BOOL isCancelled;

- (void)cancel;

@end

@implementation ZZNetworkIndicatorTimer

- (instancetype)initWithInterval:(NSTimeInterval)interval handler:(dispatch_block_t)handler {
    if (self = [super init]) {
        self.isCancelled = NO;
        
        __weak typeof(self) __weak_self = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![__weak_self isCancelled]) {
                handler();
            }
        });
    }
    return self;
}

- (void)cancel {
    self.isCancelled = YES;
}

@end

@interface ZZNetworkIndicatorController ()

@property (nonatomic, assign) NSInteger activityCount;
@property (nonatomic, strong) ZZNetworkIndicatorTimer *timer;

@end

@implementation ZZNetworkIndicatorController

- (instancetype)init {
    if (self = [super init]) {
        self.activityCount = 0;
    }
    return self;
}

+ (instancetype)sharedIndicatorController {
    static ZZNetworkIndicatorController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[ZZNetworkIndicatorController alloc] init];
    });
    return controller;
}

- (void)networkActivityDidStart {
    self.activityCount++;
    
    [self updateIndicatorVisibility];
}

- (void)networkActivityDidEnd {
    self.activityCount--;
    
    [self updateIndicatorVisibility];
}

- (void)updateIndicatorVisibility {
    NSAssert([NSThread isMainThread], @"update indicator visibility must be called in main thread");
    
    if (self.activityCount > 0) {
        [self showIndicator];
    } else {
        self.timer = [[ZZNetworkIndicatorTimer alloc] initWithInterval:1.0f handler:^{
            [self hideIndicator];
        }];
    }
}

- (void)showIndicator {
    [self.timer cancel];
    self.timer = nil;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideIndicator {
    [self.timer cancel];
    self.timer = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
