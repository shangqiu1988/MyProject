//
//  UXinWebViewController.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/20.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinWebViewController.h"

@interface UXinWebViewController ()
@property (nonatomic, copy)   NSString *urlString;
@property (nonatomic, strong) NSURL    *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy)   NSString *htmlString;
@property (nonatomic, strong) NSURL    *baseURL;

-(void)loadPage;
@end

@implementation UXinWebViewController
-(void)dealloc
{
    _urlString=nil;
    _htmlString=nil;
}
- (instancetype)initWithURLString:(NSString *)urlString
{
    self=[super init];
    if(self){
        _urlString=[urlString copy];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self=[super init];
    if(self){
        _url=url;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self=[super init];
    if(self){
        _request=request;
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    self=[super init];
    if(self){
        _htmlString=[string copy];
        _baseURL=baseURL;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    if(self.urlString){
        [self.webView loadURLString:self.urlString];
    }else if (self.url){
        [self.webView loadURL:_url];
    }else if (self.request){
        [self.webView loadRequest:self.request];
    }else if (self.htmlString){
        [self.webView loadHTMLString:self.htmlString baseURL:self.baseURL];
    }else{
        
    }
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-getter
-(UXinWebView *)webView
{
    if(_webView==nil){
        _webView=[[UXinWebView alloc]initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
             __weak typeof(self) weakSelf = self;
        [_webView setCallback:^(UXinWebViewMessage *message) {
            
        }];
        [_webView setOperateBlock:^BOOL(NSURLRequest *request) {
            
            return YES;
        }];
        [_webView setTitleBlock:^(NSString *title) {
            weakSelf.navigationItem.title=title;
        }];
        [_webView setBackBlock:^(BOOL canGoBack) {
            if(canGoBack){
                [weakSelf updateButtonItems];
            }
        }];
        
        
    }
    return _webView;
}
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"icon.bundle/nav_back"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _backItem;
}
- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _closeItem;
}
#pragma mark - event
-(void)backAction
{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [self closeSelf];
    }
}
-(void)closeSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-private
- (void)updateButtonItems
{
    if (self.webView.canGoBack && self.navigationItem.leftBarButtonItems.count != 2) {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    }
}
#pragma mark-public
- (void)registerMessageHandler
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
