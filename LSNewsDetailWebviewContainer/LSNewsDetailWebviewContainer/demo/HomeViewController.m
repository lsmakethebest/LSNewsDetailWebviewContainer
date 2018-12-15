
//
//  HomeViewController.m
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "HomeViewController.h"
#import "LSDetainViewController.h"

@interface HomeViewController ()
@end

@implementation HomeViewController
- (IBAction)clickOne:(id)sender
{
    LSDetainViewController *VC=[[LSDetainViewController alloc]init];
    VC.URLString=@"http://xueit.cn";
    VC.firstConfigute=YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)clickTwo:(id)sender {
    LSDetainViewController *VC=[[LSDetainViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}



@end
