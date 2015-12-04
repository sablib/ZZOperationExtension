//
//  ZZNetworkIndicatorController.h
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZNetworkIndicatorController : NSObject

- (void)networkActivityDidStart;
- (void)networkActivityDidEnd;

+ (instancetype)sharedIndicatorController;

@end
