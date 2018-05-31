//
//  UXinWebView.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/18.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "UXinWebViewMessage.h"
//method name key
#define methodNameKey @"methodName"

//params key
#define paramsKey     @"params"

//callback method key

#define callbackMethodKey  @"callbackMethod"






typedef void (^CallBack)( UXinWebViewMessage*   message);
typedef void (^GoBackBlock)(BOOL canGoBack);
typedef BOOL (^OperateRequest)(NSURLRequest *request);
typedef void (^TitleChange)(NSString *title);
typedef void (^JavaScriptResponse)(id response);
@interface UXinWebView : UIView<WKScriptMessageHandler>

@property(nonatomic,strong) WKWebView *  webView;
@property(nonatomic,copy) CallBack  callback;
@property(nonatomic,copy) GoBackBlock backBlock;
@property(nonatomic,copy) OperateRequest operateBlock;
@property(nonatomic,copy) TitleChange titleBlock;
- (instancetype  )initWithURLString:(NSString *)urlString;

- (instancetype  )initWithURL:(NSURL *)url;

- (instancetype  )initWithRequest:(NSURLRequest *)request;

- (instancetype  )initWithHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadPage;
- (void)goBack;
- (void)refreshPage;
- (void)reloadFromOrigin;
- (void)stopLoading;
- (void)setScalesPageToFit:(BOOL)scalesPageToFit;
- (void)goForward;
- (BOOL)canGoForward;
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;
- (void)exChangeOrgUrl:(NSURLRequest *)request;
- (BOOL)isLoading;
- (BOOL)canGoBack;
- (void)excutejavaScript:(NSString *)script responseValue:(JavaScriptResponse)responseValue;
- (void)loadURLString:(NSString *)urlString;
- (void)loadURL:(NSURL *)url;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:( NSURL *)baseURL;
- (void)registerMessageHandler:(NSString *)handler callback:(CallBack  )callback;

@end

