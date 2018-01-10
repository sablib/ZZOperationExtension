//
//  NSLock+Extension.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLock (ZZExtension)

- (id)withCriticalScope:(id(^)(void))block;

@end
