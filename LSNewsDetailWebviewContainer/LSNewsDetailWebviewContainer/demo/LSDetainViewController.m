
//
//  LSDetainViewController.m
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSDetainViewController.h"
#import "LSNewsDetailWebviewContainer.h"
#import "MJRefresh.h"
#import "UILoading.h"
@interface LSDetainViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong) NSMutableArray *datas;//底部tableview的数据

@property (nonatomic,weak) LSNewsDetailWebviewContainer *detailWebviewContainer;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@end

@implementation LSDetainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];

    if (self.firstConfigute) {
        [self setupViews1];
    }else{    
        [self setupViews2];
    }
    
    [self.view bringSubviewToFront:self.emptyView];
}
-(void)setupViews1
{
    LSNewsDetailWebviewContainer *container=[[LSNewsDetailWebviewContainer alloc]init];
    container.URLString=self.URLString;
    container.cachePolicy=NSURLRequestReturnCacheDataElseLoad;
    [container configueFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64-44)];
    container.tableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    container.tableview.mj_footer.automaticallyChangeAlpha=YES;
    container.tableview.dataSource=self;
    container.tableview.delegate=self;
    container.tableview.tableFooterView=[UIView new];
    container.webview.navigationDelegate=self;
    self.detailWebviewContainer=container;
    [self.view addSubview:container];
    [self retryClick:nil];
}
-(void)setupViews2
{
    LSNewsDetailWebviewContainer *container=[[LSNewsDetailWebviewContainer alloc]init];
    WKWebView *webview=[[WKWebView alloc]init];
    webview.backgroundColor=[UIColor whiteColor];

    UITableView *tableview=[[UITableView alloc]init];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64-44);
    [container configueWebview:webview tableview:tableview frame:frame];
    
    container.tableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    container.tableview.mj_footer.automaticallyChangeAlpha=YES;
    container.tableview.dataSource=self;
    container.tableview.delegate=self;
    container.tableview.tableFooterView=[UIView new];
    container.webview.navigationDelegate=self;
    self.detailWebviewContainer=container;
    [self.view addSubview:container];
    [self retryClick:nil];
}
- (IBAction)retryClick:(id)sender {
    
    [UILoading showMessage:@"正在加载" toView:self.view];
    if (self.firstConfigute) {
        [self.detailWebviewContainer loadRequest];
    }else{
        NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"1.json" withExtension:nil]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        [self.detailWebviewContainer loadHTMLString:dict[@"data"][@"content"]];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.emptyView.hidden=YES;
    self.datas=[NSMutableArray array];
    for (int i=0; i<15; i++) {
        [self.datas addObject:@"1"];
    }
    [self.detailWebviewContainer.tableview reloadData];
    [UILoading hideForView:self.view];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.emptyView.hidden=NO;
    [UILoading hideForView:self.view];
}

- (IBAction)commentClick:(id)sender {
    [self.detailWebviewContainer scrollToWebviewOrTableView];
}

-(void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.datas addObject:@"1"];
        [self.datas addObject:@"1"];
        [self.datas addObject:@"1"];
        if (self.datas.count>25) {
            [self.detailWebviewContainer.tableview.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.detailWebviewContainer.tableview.mj_footer endRefreshing];
        }
        [self.detailWebviewContainer.tableview reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc=[[UIViewController alloc]init];
    vc.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
