//
//  BaseTabMainViewController.m
//  XiuXiuTuanGou
//
//  Created by 王克博 on 2019/1/7.
//  Copyright © 2019 XiuXiuTuanGou. All rights reserved.
//

#import "BaseTabMainViewController.h"


@interface BaseTabMainViewController ()

@property (assign, nonatomic) BOOL isShowInviteAlertView;
@property (assign, nonatomic) BOOL isChooseAfterGet;        //是否商户选择了 下次再领 邀请入驻奖励，如果是 则不显示 奖励弹框

@end

@implementation BaseTabMainViewController

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kapplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:kapplicationDidBecomeActiveNotification object:nil];
}

//当程序进入活跃状态
- (void)applicationDidBecomeActive
{
    if (self.isCanNotCheckHaveNewShopJoin != YES) {
        _isShowInviteAlertView = YES;
       // [self checkIsHaveNewShopJoin];//
    }
    [self needReloadData];
}

////检测是否有邀请的商家入驻 可以领取奖励
//- (void)checkIsHaveNewShopJoin
//{
//    XXTGNetWorking * manager = [XXTGNetWorking sharedInstance];
//    kWeakSelf(self)
//    [manager checkIsHaveNewShopJoinCallBack:^(BOOL isSucessed, id outParam, NSString *eMsg) {
//        if (isSucessed == YES && outParam[@"data"]) {
//            weakself.inviteSuccessModel = [XXTGHomeInviteSuccessDataModel modelWithJSON:outParam];
//            if (weakself.inviteSuccessModel && weakself.inviteSuccessModel.data && weakself.inviteSuccessModel.data.count > 0) {
//                //如果有邀请成功入驻的店铺可以领取奖励，则弹框展示
//                [weakself showAllInviteSuccessAlertView];
//            }
//        }
//    }];
//}
//
//- (void)showAllInviteSuccessAlertView
//{
//    if (_isShowInviteAlertView == YES && self.inviteSuccessModel.data.count > 0 && _isChooseAfterGet != YES) {
//        _isShowInviteAlertView = NO;
//        XXTGSuccessInviteJoinAlertView * inviteJoinAlertView = [[XXTGSuccessInviteJoinAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//        inviteJoinAlertView.dataModel = self.inviteSuccessModel;
//        [[UIApplication sharedApplication].keyWindow addSubview:inviteJoinAlertView];
//        [inviteJoinAlertView show];
//        kWeakSelf(self)
//        inviteJoinAlertView.clickAfterGetButtonBlock = ^{
//            //点击下次再领
//            weakself.isChooseAfterGet = YES;
//        };
//    }
//}

@end
