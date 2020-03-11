//
//  BaseNavView.h
//  XiuXiuTuanGou
//
//  Created by 张敬 on 2018/11/6.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^dealRightNavBtnOperation) (void);

@interface BaseNavView : UIView

@property (strong, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) UIButton *leftNavBtn; //默认关闭
@property (strong, nonatomic) UIButton *leftCancelNavBtn; //默认关闭
@property (strong, nonatomic) UIButton *rightNavBtn; //默认关闭

@property (nonatomic, strong) CAShapeLayer *line; //line
@property (nonatomic, assign) float rightNavBtnW;

@property (nonatomic, copy) dealRightNavBtnOperation rightBlock;
@property (nonatomic, copy) dealRightNavBtnOperation leftBlock;

- (instancetype)initWithTitle:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
