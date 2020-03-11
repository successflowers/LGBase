//
//  BaseWebViewController.m
//  XiuXiuTuanGou
//
//  Created by 王克博 on 2018/7/25.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()
{
    UIImageView * navBarHairlineImageView;  //navigationBar分割线
}

@end

@implementation BaseWebViewController

- (void) dealloc{
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.webView setNavigationDelegate:nil];
//    [self.webView setUIDelegate:nil];
    self.mainWebView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
    //监听wkWebView的estimatedProgress属性，用于获取当前加载的进度值
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
   // navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (navBarHairlineImageView) {
        navBarHairlineImageView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (navBarHairlineImageView) {
        navBarHairlineImageView.hidden = NO;
    }
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.navView.width = KScreenWidth;
    self.navView.height = XXTG_NavBarHeight;
    
    _mainWebView.frame = CGRectMake(0, _navView.bottom, KScreenWidth, KScreenHeight - _navView.height - XXTG_SafeAreaBottomHeight);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    kWeakSelf(self);
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [weakself.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [weakself.progressView setProgress:0.0f animated:YES];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)createUI
{
    //添加导航条
    [self.view addSubview:self.navView];
    
    
    //webview
    _mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, _navView.bottom, KScreenWidth, KScreenHeight - _navView.height - XXTG_SafeAreaBottomHeight)];
    _mainWebView.delegate = self;
    _mainWebView.backgroundColor = KWhiteColor;
    _mainWebView.scrollView.bounces = NO;
    [self.view addSubview:_mainWebView];
}


- (void)createWKWebView
{
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight-XXTG_NavBarHeight-XXTG_SafeAreaBottomHeight)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 5)];
    self.progressView.progressTintColor = [UIColor greenColor];
    [self.view addSubview:self.progressView];
}


//重新back按钮方法
- (void)clickedBackButton
{
    if ([_mainWebView canGoBack]) {
        //如果可以回退，则回退
        [_mainWebView goBack];
    }else{
        //如果不能回退，则返回
        [self.navigationController popViewControllerAnimated:YES];
    }
//    if ([_webView canGoBack]) {
//        //如果可以回退，则回退
//        [_webView goBack];
//    }else{
//        //如果不能回退，则返回
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

//获取到导航条分割线
- (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
    if([view isKindOfClass: UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for(UIView * subview in view.subviews) {
        UIImageView * imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)clickedCloseButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter and getter
//导航条
- (BaseNavView *)navView{
    if (!_navView) {
        _navView = [[BaseNavView alloc] initWithTitle:@""];
        _navView.leftNavBtn.hidden = NO;
        _navView.leftCancelNavBtn.hidden = NO;
        _navView.leftNavBtn.mj_w = 30;
        _navView.leftCancelNavBtn.mj_x = _navView.leftNavBtn.right;
        kWeakSelf(self);
        _navView.leftBlock = ^{
            [weakself clickedBackButton];
        };
    }
    return _navView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
