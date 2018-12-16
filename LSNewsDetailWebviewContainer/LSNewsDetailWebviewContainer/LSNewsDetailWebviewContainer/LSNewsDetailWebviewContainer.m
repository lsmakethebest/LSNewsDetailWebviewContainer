
//
//  LSNewsDetailWebviewContainer.m
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSNewsDetailWebviewContainer.h"

@interface LSNewsDetailWebviewContainer()

/*
scrollview.contentSize=webview.contentSize+tableview.contentSize+tableview.contentInset
*/
@property (nonatomic,assign) CGFloat scrollViewContentHeight;
//webview.contentSize
@property (nonatomic,assign) CGFloat webviewContentHeight;
//tableview.contentSize
@property (nonatomic,assign) CGFloat tableviewContentHeight;

@property (nonatomic,assign) CGFloat webviewHeight;
@property (nonatomic,assign) CGFloat tableviewHeight;

@property (nonatomic,copy)NSString *HTMLString;

@property (nonatomic,assign) CGFloat lastWebviewOffsetY;
@property (nonatomic,assign) CGFloat lastTableviewOffsetY;


@end

@implementation LSNewsDetailWebviewContainer

-(void)configueFrame:(CGRect)frame
{
    WKWebView *webview=[[WKWebView alloc]init];
    webview.backgroundColor=[UIColor whiteColor];
    webview.scrollView.bounces=NO;
    webview.scrollView.showsVerticalScrollIndicator=NO;
    webview.scrollView.scrollEnabled=NO;
    
    UITableView *tableview=[[UITableView alloc]init];
    tableview.showsVerticalScrollIndicator=NO;
    tableview.scrollEnabled=NO;
    [self configueWebview:webview tableview:tableview frame:frame];
}

-(void)configueWebview:(WKWebView *)webview tableview:(UITableView *)tableview frame:(CGRect)frame
{
    self.frame=frame;
    
    webview.scrollView.bounces=NO;
    webview.scrollView.showsVerticalScrollIndicator=NO;
    webview.scrollView.scrollEnabled=NO;
    
    tableview.showsVerticalScrollIndicator=NO;
    tableview.scrollEnabled=NO;
    
    UIScrollView *scrollview=[[UIScrollView alloc]init];
    scrollview.backgroundColor=[UIColor whiteColor];
    scrollview.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.scrollview=scrollview;
    [self addSubview:scrollview];
    
    //=0.5避免网页顶部有悬浮导航必须得滑动下才显示问题
    webview.frame=CGRectMake(0, 0, frame.size.width, 0.5);
    self.webview=webview;
    [self.scrollview addSubview:webview];
    
    tableview.frame=CGRectMake(0, 0, frame.size.width, 0);
    //避免在webview finish代理方法调用之后刷新tableview数据，此时tableview显示 y=0,但是此时webview.scrollview.contentSize还没有获取到,导致会先显示tableview，在显示webview闪烁一下，所以此处先隐藏，在获取到webviewcontentSize之后再显示tableview
    tableview.hidden=YES;
    self.tableview=tableview;
    [self.scrollview addSubview:tableview];
    [self addObservers];
}

-(void)loadRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:self.cachePolicy timeoutInterval:5];
    [self.webview loadRequest:request];
}
-(void)loadHTMLString:(NSString *)HTMLString
{
    [self.webview loadHTMLString:HTMLString baseURL:nil];
}

-(void)addObservers
{
    [self.webview addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.tableview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.tableview addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)removeObservers{
    [self.webview removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableview removeObserver:self forKeyPath:@"contentSize"];
    [self.tableview removeObserver:self forKeyPath:@"contentInset"];
    [self.scrollview removeObserver:self forKeyPath:@"contentOffset"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"scrollView.contentSize"]&&object==self.webview) {
        CGFloat height=[change[NSKeyValueChangeNewKey] CGSizeValue].height;
        [self updateContentHeight:height isWebView:YES];
        if (self.tableview.hidden) {
            self.tableview.hidden=NO;
        }
    }
    else if ([keyPath isEqualToString:@"contentSize"]&&object==self.tableview) {
        CGFloat height=[change[NSKeyValueChangeNewKey] CGSizeValue].height;
        [self updateContentHeight:height+self.tableview.contentInset.bottom isWebView:NO];
    }
    else if ([keyPath isEqualToString:@"contentInset"]&&object==self.tableview) {
        UIEdgeInsets inset =[change[NSKeyValueChangeNewKey] UIEdgeInsetsValue];
        [self updateContentHeight:self.tableview.contentSize.height+inset.top+inset.bottom isWebView:NO];
    }
    else if([keyPath isEqualToString:@"contentOffset"]&&object==self.scrollview) {
        CGFloat y=[change[NSKeyValueChangeNewKey] CGPointValue].y;
        [self scrollviewOffsetChange:y];
    }
}

-(void)updateContentHeight:(CGFloat)height isWebView:(BOOL)isWebView
{
    if (isWebView) {
        if (self.webviewContentHeight==height) {
            return;
        }
        self.webviewContentHeight=height;
        CGRect webviewFrame=self.webview.frame;
        if (height>=self.frame.size.height) {
            //webview内容很大 大于屏幕显示区域高
            webviewFrame.size.height=self.frame.size.height;
            self.webview.frame=webviewFrame;
            self.webviewHeight=self.frame.size.height;
        }else{
            //webview内容很短 比屏幕高度小
            webviewFrame.size.height=height;
            self.webview.frame=webviewFrame;
            self.webviewHeight=height;
        }
        CGRect tableviewFrame=self.tableview.frame;
        tableviewFrame.origin.y=self.webviewContentHeight;
        self.tableview.frame=tableviewFrame;
    }else{
        if (self.tableviewContentHeight==height) {
            return;
        }
        
        self.tableviewContentHeight=height;
        CGRect tableviewFrame=self.tableview.frame;
        if (height>=self.frame.size.height) {
            tableviewFrame.size.height=self.frame.size.height;
            self.tableview.frame=tableviewFrame;
            self.tableviewHeight=self.frame.size.height;
        }else{
            tableviewFrame.size.height=height;
            self.tableview.frame=tableviewFrame;
            self.webviewHeight=height;
        }
    }
     self.scrollViewContentHeight=self.webviewContentHeight+self.tableviewContentHeight;
    self.scrollview.contentSize=CGSizeMake(self.frame.size.width,self.scrollViewContentHeight);
}

-(void)scrollviewOffsetChange:(CGFloat)offsetY
{
    CGFloat y=offsetY;
    CGFloat viewHeight=self.frame.size.height;
    if (y<=(self.webviewContentHeight-viewHeight)) {
        //屏幕上只显示webview的界面 当y在大一点的时候就开始显示 tableview了
        CGRect webviewFrame=self.webview.frame;
        if (y<0) {
            y=0;
        }
        //避免webview内容没有屏幕高 导致在向下拉动的时候引起的bug
        webviewFrame.origin.y=y;
        self.webview.frame=webviewFrame;
        [self.webview.scrollView setContentOffset:CGPointMake(0, y)];
    }else{
        if(self.webviewContentHeight-viewHeight>0){
            CGRect webviewFrame=self.webview.frame;
            if (webviewFrame.origin.y!=self.webviewContentHeight-viewHeight) {
                webviewFrame.origin.y=self.webviewContentHeight-viewHeight;
                self.webview.frame=webviewFrame;
            }
            if (self.webview.scrollView.contentOffset.y!=self.webviewContentHeight-viewHeight) {
                [self.webview.scrollView setContentOffset:CGPointMake(0, self.webviewContentHeight-viewHeight)];
            }
        }
        if (y>=self.webviewContentHeight) {
            //tableview刚开始显示在 scrollview上方
            if (self.tableviewContentHeight>=viewHeight) {
                CGRect frame=self.tableview.frame;
                frame.origin.y=y;
                self.tableview.frame=frame;
                [self.tableview setContentOffset:CGPointMake(0, y-self.webviewContentHeight)];
            }
            
        }else{
            CGRect tableviewFrame=self.tableview.frame;
            if (tableviewFrame.origin.y!=self.webviewContentHeight) {
                tableviewFrame.origin.y=self.webviewContentHeight;
                self.tableview.frame=tableviewFrame;
            }
            if (self.tableview.contentOffset.y!=0) {
                [self.tableview setContentOffset:CGPointMake(0, 0)];
            }
        }
    }
}
-(void)scrollToWebviewOrTableView
{
    CGFloat y=self.scrollview.contentOffset.y;
    
    if (y>=self.webviewContentHeight) {
        self.lastTableviewOffsetY=y;
        //webview已经全部不显示了
        [self.scrollview setContentOffset:CGPointMake(0, self.lastWebviewOffsetY) animated:YES];
    }else{
        //滚动到评论位置
        if (self.lastTableviewOffsetY==0) {
            if (self.tableviewContentHeight>=self.frame.size.height) {
                self.lastTableviewOffsetY=self.scrollViewContentHeight-self.tableviewContentHeight;
            }else{
                self.lastTableviewOffsetY=self.webviewContentHeight-(self.frame.size.height-self.tableviewContentHeight);
            }
        }
        self.lastWebviewOffsetY=y;
        [self.scrollview setContentOffset:CGPointMake(0, self.lastTableviewOffsetY) animated:YES];
    }
}

-(void)dealloc
{
    [self removeObservers];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"1111111111");
}

@end
