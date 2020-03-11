//
//  BaseViewController.h
//  XiuXiuTuanGou
//
//  Created by 王克博 on 2018/7/10.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavView.h"

static NSString * const startNetworkingReminder = @"客官,正在玩命加载……";
static NSString * const finishNetworkingReminder = @"客官,网络加载完毕";
static NSString * const failtureNetworkingReminder = @"客官,由于网络问题，尽力了……";
static NSString * const noOrderString = @"客官,没有任何订单哦～";

static NSString * const noOrderMsg = @"没有订单数据";
static NSString * const noRefundOrderMsg = @"没有退款单";

static NSString * const noNetworkingString = @"获取数据失败，请重试";
static NSString * const noChatString = @"客官，还没有消息哦~";
//static NSString const *startNetworkingReminder = @"";

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIButton *reloadBtn;  //重新加载按钮
@property (nonatomic,strong) UIButton *leftNavBtn;  //左边的导航按钮

@property (nonatomic, strong) BaseNavView *baseNavView; //导航条

- (void)needReloadData;

// 显示/隐藏 加载中
- (void)showProgressView;
- (void)hideProgressView;

//设置跳转相册/图库
- (void)setupOpenURLForPhototAndCamera;


//设置无网、获取数据失败、数据为空 情况下的图片
- (void)setReloadBtnImageToError;
- (void)setReloadBtnImageToEmpty:(NSString *)emptyText;


//UITabelView.Section.分割线
- (UIView *)addTableViewSectionSegmentationLineByY:(CGFloat)y;

//拨打电话
- (void)goToPhone:(NSString *)phoneNumber;


#if defined __cplusplus
extern "C" {
#endif
    
    void soundplay(void);

#if defined __cplusplus
};
#endif

@end
