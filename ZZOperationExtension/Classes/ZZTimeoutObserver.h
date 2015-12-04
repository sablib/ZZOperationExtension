//
//  ZZTimeoutObserver.h
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZOperationObserver.h"

@interface ZZTimeoutObserver : NSObject <ZZOperationObserver>

- (instancetype)initWithTimeoutInterval:(NSTimeInterval)interval;

@end
