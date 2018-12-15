//
//  UILoading.h
//  ToGoProject
//
//  Created by liusong on 2017/9/1.
//  Copyright © 2017年 TOGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILoading : UIView


+ (instancetype)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)hideForView:(UIView *)view;


+ (instancetype)showMessage:(NSString *)message;
+ (void)hide;


@end
