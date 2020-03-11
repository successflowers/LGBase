//
//  BaseTableViewViewController.h
//  XiuXiuTuanGou
//
//  Created by 张敬 on 2018/8/7.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import "BaseViewController.h"
//#import <FMTagsView/FMTagsView.h>

@interface BaseTableViewViewController : BaseViewController

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, assign) BOOL isRefreshMore; //是否加载更多
@property (nonatomic, assign) BOOL isRefresh; //是否下拉刷新
@property (nonatomic, assign) BOOL isWhole; //是否是全部

@property (nonatomic, assign) NSInteger page; //当前第几页

@property (nonatomic, strong) NSMutableArray *dataLists;

//- (FMTagsView *)setupFMTagsView;
//
//- (float)getFMTagViewHeight:(FMTagsView *)tagsView;

- (void)needReloadData; //下拉加载更多方法
- (void)needReloadDataMore; //上拉加载更多

- (void)cleanDataLists; //清空数据源

- (void)dealIsRefreshMoreButNoData; //处理加载更多条件下无更多数据

- (void)reloadTableViewByIndex:(NSInteger)index; //局部刷新_刷新第几个section

@end
