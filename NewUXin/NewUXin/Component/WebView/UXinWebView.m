//
//  UXinWebView.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/18.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinWebView.h"
#import <Masonry/Masonry.h>
@interface UXinWebView ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong) UIProgressView *progresView;
@property(nonatomic,copy) NSString *urlString;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,copy)  NSString *htmlString;
@property(nonatomic,strong) NSURL *baseURL;
@property (nonatomic, strong) NSURLRequest *request;
@property(nonatomic,strong) UIView *errorView;
@property(nonatomic,strong) NSURLRequest *origRequest;
@property(nonatomic,strong) NSURLRequest *currentRequest;
@end

@implementation UXinWebView
#pragma mark - LifeCycle
-(void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"title"];
    _callback=nil;
}
-(instancetype)init
{
    self=[super init];
    if(self){
       
        [self initUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}
-(instancetype)initWithURLString:(NSString *)urlString
{
    self=[super init];
    if(self){
        _urlString=urlString;
        [self initUI];
    }
    return self;
}
- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
        [self initUI];
    }
    
    return self;
}


- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _request = request;
        [self initUI];
    }
    
    return self;
}


- (instancetype)initWithHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _htmlString = string;
        _baseURL = baseURL;
        [self initUI];
    }
    
    return self;
}

-(void)didMoveToSuperview
{
    self.frame=self.superview.bounds;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.webView.frame=self.bounds;
    self.progresView.frame=CGRectMake(0, 0, self.bounds.size.width, 0);
}
#pragma mark-private
-(void)addObserver
{
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"canGoBack"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
}
-(void)initUI
{
    [self addSubview:self.webView];
    [self addSubview:self.progresView];
    [self addObserver];
}
- (void)setErrorViewHidden:(BOOL)hidden
{
    if (hidden) {
        if([self.subviews containsObject:self.errorView]==YES){
        [self.errorView removeFromSuperview];
        }
    } else {
        if([self.subviews containsObject:self.errorView]==NO){
        [self addSubview:self.errorView];
        }
    }
}
-(void)dealWithmessage:(WKScriptMessage *)message
{
    if([message.body isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic=(NSDictionary *)message.body;
        UXinWebViewMessage *webMessage=[[UXinWebViewMessage alloc] init];
        webMessage.methodName=dic[methodNameKey];
        webMessage.params=dic[paramsKey];
        webMessage.callbackMethod=dic[callbackMethodKey];
        if(_callback){
            _callback(webMessage);
        }
    }else{
        if(_callback){
            _callback(nil);
        }
    }
}
-(void)hideProgress
{
    self.progresView.hidden = YES;
    [self.progresView setProgress:0 animated:NO];
}
-(void)updateProgress:(float)progress
{
    self.progresView.hidden=NO;
    [self.progresView setProgress:progress animated:NO];
}
#pragma mark-public
- (void)reloadFromOrigin
{
    [self.webView reloadFromOrigin];
}
- (void)stopLoading
{
    [self.webView stopLoading];
}
- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    NSString *jScript = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    if(scalesPageToFit)
    {
        
        WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [self.webView.configuration.userContentController addUserScript:wkUScript];
    }
    else
    {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.webView.configuration.userContentController.userScripts];
        for (WKUserScript *wkUScript in array)
        {
            if([wkUScript.source isEqual:jScript])
            {
                [array removeObject:wkUScript];
                break;
            }
        }
        for (WKUserScript *wkUScript in array)
        {
            [self.webView.configuration.userContentController addUserScript:wkUScript];
        }
    }
}
- (void)goForward
{
    if([self.webView canGoForward]){
        [self.webView goForward];
    }
}
- (BOOL)canGoForward
{
    return self.webView.canGoForward;
}
- (void)exChangeOrgUrl:(NSURLRequest *)request
{
    self.origRequest=request;
}
- (NSInteger)countOfHistory
{
    WKWebView* webView = self.webView;
    return webView.backForwardList.backList.count;
}

- (void)gobackWithStep:(NSInteger)step
{
    if(step>0){
    WKWebView* webView = self.webView;
    WKBackForwardListItem* backItem = webView.backForwardList.backList[step];
    [webView goToBackForwardListItem:backItem];
    }
}
- (BOOL)isLoading
{
    return [self.webView isLoading];
}
- (BOOL)canGoBack
{
    return self.webView.canGoBack;
}
- (void)registerMessageHandler:(NSString *)handler callback:(CallBack)callback
{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:handler];
    _callback=[callback copy];
}
-(void)excutejavaScript:(NSString *)script responseValue:(JavaScriptResponse)responseValue
{
    [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if(responseValue){
            responseValue(response);
        }
    }];
}
- (void)loadPage
{
    if (self.urlString.length > 0) {
        [self loadURLString:self.urlString];
    } else if (self.url) {
        [self loadURL:self.url];
    } else if (self.request) {
        [self loadRequest:self.request];
    } else if (self.htmlString.length > 0 || self.baseURL) {
        [self loadHTMLString:self.htmlString baseURL:self.baseURL];
    }
}
- (void)refreshPage
{
    if (self.webView.URL) {
        [self.webView reload];
    } else {
        [self loadPage];
    }
    [self setErrorViewHidden:YES];
}
- (void)goBack
{
    if(self.webView){
        [self.webView goBack];
    }
}
- (void)loadURLString:(NSString *)urlString
{
      [self loadURL:[NSURL URLWithString:urlString]];
}
- (void)loadURL:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self loadRequest:request];
}
- (void)loadRequest:(NSURLRequest *)request
{
      [self.webView loadRequest:request];
}
- (void)loadHTMLString:(NSString *)string baseURL:( NSURL *)baseURL
{
     [self.webView loadHTMLString:string baseURL:baseURL];
}
#pragma mark-getter
-(WKWebView *)webView
{
    if(!_webView){
        WKWebViewConfiguration *configuration=[[WKWebViewConfiguration alloc]init];
        _webView=[[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

-(UIProgressView *)progresView
{
    if(!_progresView){
        _progresView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _progresView.tintColor = [UIColor greenColor];
        _progresView.trackTintColor = [UIColor clearColor];
        _progresView.hidden = YES;
    }
    return _progresView;
}
- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:self.bounds];
        _errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _errorView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshPage)];
        _errorView.userInteractionEnabled = YES;
        [_errorView addGestureRecognizer:gesture];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 60)];
        [button setTitle:@"轻触重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventTouchUpInside];
        button.center = _errorView.center;
        [_errorView addSubview:button];
    }
    
    return _errorView;
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object==self.webView){
        if([keyPath  isEqualToString:@"estimatedProgress"]){
            CGFloat progress=[[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if(progress ==1){
                [self hideProgress];
            }else{
                [self updateProgress:progress];
            }
        }else if ([keyPath isEqualToString:@"canGoBack"]){
            if([self.webView canGoBack]){
                if(_backBlock){
                    _backBlock(YES);
                }
            }else{
                if(_backBlock){
                _backBlock(NO);
                }
            }
        }else if ([keyPath isEqualToString:@"title"]){
            NSString *title=self.webView.title;
            if(title&&[title isKindOfClass:[NSString class]]&&title.length>0){
                if(_titleBlock){
                    _titleBlock(title);
                }
            }
        }
    }
}
#pragma mark-WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self hideProgress];
    [self setErrorViewHidden:YES];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self hideProgress];
    [self setErrorViewHidden:YES];
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL result= YES;
    if(_operateBlock){
      result = _operateBlock(navigationAction.request);
    }
    if(result){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self dealWithmessage:message];
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
   
    completionHandler();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
