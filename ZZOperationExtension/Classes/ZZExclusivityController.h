//
//  ZZExclusivityController.h
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZOperation;

@interface ZZExclusivityController : NSObject

+ (instancetype)sharedExclusivityController;

- (void)addOperation:(ZZOperation *)operatoin withCategories:(NSArray<NSString *> *)categories;
- (void)removeOperation:(ZZOperation *)operatoin withCategories:(NSArray<NSString *> *)categories;

@end
