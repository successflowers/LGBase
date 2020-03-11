//
//  BaseViewController.m
//  XiuXiuTuanGou
//
//  Created by 王克博 on 2018/7/10.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import "BaseViewController.h"
//#import "MBProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <LGCategory/NSObject+AutoFitSize.h>
#import <LGUtils/FontAndColorMacros.h>
#import <LGUtils/AutoLayerMacros.h>
//#import "XXTGShareView.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView * activityBGView;
@property (strong, nonatomic) UIActivityIndicatorView * activityView;
//@property (strong, nonatomic) XXTGShareView * shareView;

//分享相关字段
@property (copy, nonatomic) NSString * shareTitle;
@property (copy, nonatomic) NSString * shareDescription;
@property (copy, nonatomic) NSString * shareImage;
@property (strong, nonatomic) UIImage * shareUsedImage;
@property (copy, nonatomic) NSString * shareUrl;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = mBackgroudColor;
    [self.view addSubview:self.reloadBtn];
    
    //添加导航条
    [self.view addSubview:self.baseNavView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   // self.navigationController.navigationBar.hidden = NO;
}

- (void)needReloadData
{
    //统一请求刷新方法
}

//导航条
- (BaseNavView *)baseNavView{
    if (!_baseNavView) {
        _baseNavView = [[BaseNavView alloc] initWithTitle:@""];
    }
    return _baseNavView;
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
//    self.baseNavView.width = KScreenWidth;
//    self.baseNavView.height = XXTG_NavBarHeight;
//
//    _reloadBtn.mj_x = (KScreenWidth-_reloadBtn.width)/2.0;
//    _reloadBtn.centerY = KScreenHeight/2.0-XXTG_NavBarHeight;
    
}

#pragma mark - progressView (显示/隐藏 加载中)

- (void)showProgressView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.activityBGView];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [self.activityView startAnimating];
}

- (void)hideProgressView
{
    [self.activityView stopAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    [self.activityBGView removeFromSuperview];
}


//MARK: - 设置 无网、获取数据失败、数据为空 情况下刷新按钮图片和提示文字
- (void)setReloadBtnImageToError
{
    //设置无网、获取数据失败 的图片
    [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingError"] forState:UIControlStateNormal];
    [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingError"] forState:UIControlStateHighlighted];
    [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake([self fitSize:140], -[self fitSize:50], 0, -[self fitSize:50])];

    [_reloadBtn setTitle:@"咦？怎么木有网了呢~" forState:UIControlStateNormal];
}

- (void)setReloadBtnImageToEmpty:(NSString *)emptyText
{
    //设置 数据为空 情况下的图片
    [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingEmpty"] forState:UIControlStateNormal];
    [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingEmpty"] forState:UIControlStateHighlighted];
    [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake([self fitSize:165], -[self fitSize:50], 0, -[self fitSize:50])];

    if (emptyText && emptyText.length > 0) {
        [_reloadBtn setTitle:emptyText forState:UIControlStateNormal];
    }else {
        [_reloadBtn setTitle:@"暂无数据" forState:UIControlStateNormal];
    }
}

//MARK: -

- (void)setupOpenURLForPhototAndCamera{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}


- (void)goToPhone:(NSString *)phoneNumber
{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
    }
}


//void soundCompleteCallBack(SystemSoundID soundID, void *clientData){
//    NSLog(@"播放完成");
//}

//void soundplay(){
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"openredbag" ofType:@"mp3"];
//    NSURL *fileUrl = [NSURL URLWithString:filePath];
//    SystemSoundID soundID = 0;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
//    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
//    AudioServicesPlaySystemSound(soundID);
//}


//压缩图片到指定尺寸
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


//MARK: - getter
- (UIButton *)reloadBtn{
    
    if (!_reloadBtn) {
        
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadBtn.frame = CGRectMake(0, 0, [self fitSize:220], [self fitSize:196]);
        
        [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingError"] forState:UIControlStateNormal];
        [_reloadBtn setTitle:@"咦？怎么木有网了呢~" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(needReloadData) forControlEvents:(UIControlEventTouchUpInside)];
        [_reloadBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = mFont([self fitSize:14]);
        [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake([self fitSize:140], -[self fitSize:50], 0, -[self fitSize:50])];
        _reloadBtn.titleLabel.numberOfLines = 0;
        _reloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _reloadBtn.hidden = YES;
    }
    return _reloadBtn;
}

//- (XXTGShareView *)shareView
//{
//    if (!_shareView) {
//        _shareView = [[XXTGShareView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//    }
//    return _shareView;
//}

- (UIView *)activityBGView
{
    if (!_activityBGView) {
        _activityBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _activityBGView.clipsToBounds = YES;
        _activityBGView.backgroundColor = RGBA(0, 0, 0, 0.6);
        _activityBGView.userInteractionEnabled = NO;
        
        //黑色小背景
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.cornerRadius = 6;
        bgView.clipsToBounds = YES;
        [self.activityBGView addSubview:bgView];
        bgView.center = _activityBGView.center;
        [_activityBGView addSubview:self.activityView];
        self.activityView.center = _activityBGView.center;
    }
    return _activityBGView;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _activityView;
}

#pragma mark - UITableView.Section.分割线
- (UIView *)addTableViewSectionSegmentationLineByY:(CGFloat)y{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = mBackgroudColor;
    
    CAShapeLayer *line = [CAShapeLayer layer];
    line.fillColor = UIColorFromRGB(0xD9D9D9).CGColor;
    line.fillColor = UIColorFromRGB(0xF6F6F6).CGColor;

    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, KScreenWidth, 0.25)];
    line.path = path.CGPath;
    [view.layer addSublayer:line];
    
    return view;
}


- (UIStatusBarStyle) preferredStatusBarStyle{
    ///这里设置黑色
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
