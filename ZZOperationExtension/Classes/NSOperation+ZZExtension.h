//
//  NSOperation+Extension.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (ZZExtension)

- (void)zz_addCompletionBlock:(dispatch_block_t)block;
- (void)zz_addDependencies:(NSArray<NSOperation *> *)dependencies;

@end
