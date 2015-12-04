//
//  ZZHelper.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZHelper.h"

@implementation ZZHelper

+ (UIViewController *)topMostVC {
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    
    if ([top isKindOfClass:[UINavigationController class]]) {
        UINavigationController *vc = (UINavigationController *)top;
        return vc.topViewController;
    } else{
        return top;
    }
}

@end
