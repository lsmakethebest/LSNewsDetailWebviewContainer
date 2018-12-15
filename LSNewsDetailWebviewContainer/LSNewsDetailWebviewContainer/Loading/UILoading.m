



//
//  UILoading.m
//  ToGoProject
//
//  Created by liusong on 2017/9/1.
//  Copyright © 2017年 TOGO. All rights reserved.
//

#import "UILoading.h"

@implementation UILoading


+(instancetype)showMessage:(NSString *)message
{
   return  [self showMessage:message toView:[[UIApplication sharedApplication].delegate window]];
}

+(instancetype)showMessage:(NSString *)message toView:(UIView *)view
{
    [self hideForView:view];
    UILoading *loadingView = [[UILoading alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    loadingView.backgroundColor = [UIColor whiteColor];
    [view addSubview:loadingView];
    CGSize lableSize =[self sizeWithfont:[UIFont systemFontOfSize:14] text:message];
    UIImageView * backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 55+26+lableSize.width, 45)];
    backgroundImage.image =[UIImage imageNamed:@"loding_beijing"];
    [backgroundImage setCenter:CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)];
    [loadingView addSubview:backgroundImage];
    
    
    UIImageView * loadingIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, (backgroundImage.bounds.size.height-26)/2, 26, 26)];
    loadingIcon.image = [UIImage imageNamed:@"loding_donghua"];
    [backgroundImage addSubview:loadingIcon];
    
    UILabel * promitLabel = [[UILabel alloc]init];
    promitLabel.frame =CGRectMake(CGRectGetMaxX(loadingIcon.frame)+20, 0, lableSize.width, backgroundImage.bounds.size.height);
    promitLabel.textColor = [UIColor whiteColor];
    promitLabel.textAlignment = NSTextAlignmentCenter;
    promitLabel.backgroundColor = [UIColor clearColor];
    promitLabel.text = message;
    promitLabel.font = [UIFont systemFontOfSize:14];
    [backgroundImage addSubview:promitLabel];
    
    //------- 旋转动画 -------//
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    // 围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    // 旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    
    // 添加动画
    [loadingIcon.layer addAnimation:animation forKey:nil];
    return loadingView;
}

+(void)hideForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            [subview removeFromSuperview];
        }
    }
}

+(void)hide
{
   UIWindow *window= [[UIApplication sharedApplication].delegate window];
    [self hideForView:window];

}
+ (CGSize)sizeWithfont:(UIFont *)font  text:(NSString*)text{
    
    CGSize size;
    if ([UIDevice currentDevice].systemVersion.doubleValue< 7.0) {
        size = [text sizeWithFont:font];
    } else {
        size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    }
    return size;
}
@end
