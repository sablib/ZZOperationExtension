//
//  ZZURLSessionTaskOperation.h
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZOperation.h"

@interface ZZURLSessionTaskOperation : ZZOperation

@property (nonatomic, strong) NSURLSessionTask *task;

- (instancetype)initWithTask:(NSURLSessionTask *)task;

@end
