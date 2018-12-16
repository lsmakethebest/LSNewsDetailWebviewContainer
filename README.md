# 中文说明
`LSNewsDetailWebviewContainer`是一个可快速集成的新闻详情界面框架,类似今日头条，腾讯新闻，网易新闻等，上面webview(显示网页文章内容)，下面tableview(显示评论列表)

- 特性
> 1.可以加载URL也可以加载HTML字符串

> 2.可以使用默认的WKWWebview、UITableview，也可以自定义用参数传入

> 3.既可以使用masonry，也可以使用frame(如果使用frame，那么打电话那种界面需要自己适配好，一旦外界适配好那么里面子控件会自动适配)

#### 手动安装
通过 Clone or download 下载`LSNewsDetailWebviewContainer` 文件夹内的所有内容。将`LSNewsDetailWebviewContainer`文件夹下的`LSNewsDetailWebviewContainer.h`,`LSNewsDetailWebviewContainer.m`拖到你的项目里，然后import `LSNewsDetailWebviewContainer.h`
#### 使用方式
- 1.加载URL
```
LSNewsDetailWebviewContainer *container=[[LSNewsDetailWebviewContainer alloc]init];
container.URLString=@"http://xueit.cn";;//设置请求地址
container.cachePolicy=NSURLRequestReturnCacheDataElseLoad;//缓存策略
container.scrollview.delegate=self;//监听整个大scrollview.contentOffset的变化
container.tableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
container.tableview.mj_footer.automaticallyChangeAlpha=YES;
container.tableview.dataSource=self;
container.tableview.delegate=self;
container.tableview.tableFooterView=[UIView new];
container.webview.navigationDelegate=self;
self.detailWebviewContainer=container;
[self.view addSubview:container];
[container mas_makeConstraints:^(MASConstraintMaker *make) {
make.top.left.right.mas_equalTo(0);
make.bottom.mas_equalTo(-44);
}];
//加载URL请求
[container loadRequest];
```
- 2.加载HTML字符串 使用自定义WKWebview和UITableView(此处仅为演示，不是非得这么组合用，你也可以加载HTML使用默认的webview和tableview)
```
LSNewsDetailWebviewContainer *container=[[LSNewsDetailWebviewContainer alloc]init];
container.URLString=@"http://xueit.cn";;//设置请求地址
container.cachePolicy=NSURLRequestReturnCacheDataElseLoad;//缓存策略
container.scrollview.delegate=self;//监听整个大scrollview.contentOffset的变化
container.tableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
container.tableview.mj_footer.automaticallyChangeAlpha=YES;
container.tableview.dataSource=self;
container.tableview.delegate=self;
container.tableview.tableFooterView=[UIView new];
container.webview.navigationDelegate=self;
self.detailWebviewContainer=container;
[self.view addSubview:container];
container.frame=CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64-44);
//加载HTML字符串
NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"1.json" withExtension:nil]];
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
[self.detailWebviewContainer loadHTMLString:dict[@"data"][@"content"]];
```
# 演示图，具体其他演示还请下载demo查看
![image](https://github.com/lsmakethebest/LSNewsDetailWebviewContainer/blob/master//demo.gif)
