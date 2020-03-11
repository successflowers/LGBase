//
//  BaseWebViewController.h
//  XiuXiuTuanGou
//
//  Created by 王克博 on 2018/7/25.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : BaseViewController <UIWebViewDelegate, WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) UIWebView * mainWebView;

@property (nonatomic, strong) BaseNavView *navView; //导航条
@property (strong, nonatomic) WKWebView * webView;
@property (strong, nonatomic) UIProgressView * progressView;

@end
