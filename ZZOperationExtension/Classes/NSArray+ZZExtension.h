//
//  NSArray+Extension.h
//  aaa
//
//  Created by 张凯 on 15/10/21.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^ZZMapBlock)(id each);
typedef BOOL(^ZZFilterBlock)(id each);


@interface NSArray (ZZExtension)

- (instancetype)zz_map:(ZZMapBlock)block;
- (instancetype)zz_filter:(ZZFilterBlock)block;

- (instancetype)zz_arrayByRemoveObjectAtIndex:(NSUInteger)index;

@end
