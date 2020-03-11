//
//  BaseTableViewViewController.m
//  XiuXiuTuanGou
//
//  Created by 张敬 on 2018/8/7.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import "BaseTableViewViewController.h"

@interface BaseTableViewViewController ()<UITableViewDelegate, UITableViewDataSource, FMTagsViewDelegate>

@end

@implementation BaseTableViewViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _page = 0;
    _isRefresh = NO;
    _isRefreshMore = NO;
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    
    self.mTableView.frame = CGRectMake(0, 0, KScreenWidth , 0);
    self.mTableView.mj_y = self.baseNavView.bottom;
    self.mTableView.height = KScreenHeight - self.baseNavView.height;
    
}

//MARK: - FMTagsViewDelegate
- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//MARK: - 集成下拉刷新控件
- (void)setupDownRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(needReloadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _mTableView.mj_header = header;
   // [_mTableView.mj_header beginRefreshing];
}

- (void)needReloadData
{
    _page = 0;
    _isRefresh = YES;
   // [self getMerchantsStoreList];
}

- (void)needReloadDataMore
{
    _page += 20;
    _isRefreshMore = YES;
    //[self getMerchantsStoreList];
}

//集成上拉加载更多控件
- (void)setupTopRefreshs
{
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(needReloadDataMore)];
    _mTableView.mj_footer = footer;
    //结束尾部刷新
}


- (void)cleanDataLists
{
    kWeakSelf(self);
    if (weakself.dataLists.count>0 && weakself.isRefresh == YES) {
        [weakself.dataLists removeAllObjects];
    }
}

- (void)dealIsRefreshMoreButNoData
{
    kWeakSelf(self);
    if (!weakself.isRefreshMore) {
        weakself.reloadBtn.hidden = NO;
        [weakself.reloadBtn setTitle:@"客官，期待更多店铺入驻～" forState:UIControlStateNormal];
    }else {
        [weakself.mTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)reloadTableViewByIndex:(NSInteger)index
{
    kWeakSelf(self);
    NSIndexSet *nd = [[NSIndexSet alloc] initWithIndex:index]; //刷新第几个section
    [weakself.mTableView reloadSections:nd withRowAnimation:UITableViewRowAnimationNone];
}

//UITableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    CGFloat sectionHeaderHeight = [self autoFitSizeWidth_375:100];
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
 */

//MARK: - Setter and Getter Methods
- (UITableView *)mTableView
{
    if (!_mTableView) {
        
        CGRect frame = CGRectZero;
        _mTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _mTableView.backgroundColor = KWhiteColor;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
    
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _mTableView.separatorColor = KClearColor;
        _mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self setupDownRefresh]; //下拉刷新
        [self setupTopRefreshs]; //上拉加载更多
    }
    return _mTableView;
}

- (NSMutableArray *)dataLists
{
    if (!_dataLists) {
        _dataLists = [NSMutableArray array];
    }
    return _dataLists;
}

/*
- (FMTagsView *)setupFMTagsView
{
    FMTagsView *tagsView = [[FMTagsView alloc] initWithFrame: CGRectMake(15, 0, KScreenWidth, 300)];
    
    tagsView.contentInsets = UIEdgeInsetsZero;
    tagsView.tagInsets = UIEdgeInsetsMake([self fitSize:10],
                                          [self fitSize:26],
                                          [self fitSize:10],
                                          [self fitSize:26]);
    
    tagsView.tagFont = mFont([self fitSize:14]);
    tagsView.tagSelectedFont = mFont([self fitSize:14]);
    tagsView.tagBorderWidth = 1;
    tagsView.tagcornerRadius = 5;
    tagsView.lineSpacing = [self fitSize:8];
    tagsView.interitemSpacing = [self fitSize:8];
    tagsView.tagHeight = [self fitSize:40];
    tagsView.tagBorderColor = UIColorFromRGB(0xDADADA);
    tagsView.tagSelectedBorderColor = mMainColor;
    tagsView.tagBackgroundColor = mBackgroudColor;
    tagsView.tagSelectedBackgroundColor = mMainColor;
    tagsView.tagTextColor = UIColorFromRGB(0x999999);
    tagsView.delegate = self;
    tagsView.allowsMultipleSelection = YES;
    
    return tagsView;
}


- (float)getFMTagViewHeight:(FMTagsView *)tagsView
{
    CGSize contentSize = tagsView.collectionView.collectionViewLayout.collectionViewContentSize;
    return contentSize.height;
}
 */

@end
