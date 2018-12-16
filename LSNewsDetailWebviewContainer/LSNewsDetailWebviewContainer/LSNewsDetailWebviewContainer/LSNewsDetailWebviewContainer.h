//
//  LSNewsDetailWebviewContainer.h
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface LSNewsDetailWebviewContainer : UIView

//URLString 字符串地址
@property (nonatomic,copy)NSString *URLString;
//缓存策略
@property (nonatomic,assign) NSURLRequestCachePolicy cachePolicy;

//包含WKWebView的scrollview
@property (nonatomic,weak) UIScrollView *scrollview;
//顶部webview
@property (nonatomic,weak) WKWebView *webview;
//底部评论列表
@property (nonatomic,weak) UITableView *tableview;

//自定义WKWebview和UITableview 不使用默认创建的
-(void)configueWebview:(WKWebView*)webview tableview:(UITableView*)tableview;

//加载或重新加载URL
-(void)loadRequest;

//加载html字符串
-(void)loadHTMLString:(NSString*)HTMLString;

//滚动到webview或tableview 内部会自动判断
-(void)scrollToWebviewOrTableView;

@end
