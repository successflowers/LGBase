//
//  BaseTabMainViewController.h
//  XiuXiuTuanGou
//
//  Created by 王克博 on 2019/1/7.
//  Copyright © 2019 XiuXiuTuanGou. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTabMainViewController : BaseViewController

@property (assign, nonatomic) BOOL isCanNotCheckHaveNewShopJoin;   //是否不允许调用检测是否用新商户入驻请求


//当程序进入活跃状态
- (void)applicationDidBecomeActive;

@end

NS_ASSUME_NONNULL_END
