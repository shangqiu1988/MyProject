//
//  UXinWebViewController.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/20.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXinWebView.h"
#import "UXinWebViewMessage.h"
@interface UXinWebViewController : UIViewController
{
   
}
@property (nonatomic,strong)  UXinWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
- (instancetype)initWithURLString:(NSString *)urlString;

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initWithHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)registerMessageHandler;
@end
