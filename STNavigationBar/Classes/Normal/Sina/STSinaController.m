//
//  STSinaController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STSinaController.h"
#import "STNavigationBar.h"
#import "STCustomTableView.h"
#import "STSinaHeaderView.h"
#import "STSinaToolBar.h"
#import "STSinaCellContentView.h"
#import "AppDelegate.h"
#import "STSinaSubTableViewController.h"

static CGFloat kSinaHeaderViewHeight = 250.0;
static CGFloat kSinaToolsBarHeight = 44.0;

@interface STSinaController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet STCustomTableView *tableView;
@property (nonatomic, strong) STSinaHeaderView *headerView;
@property (nonatomic, strong) STSinaToolBar *toolBar;
@property (nonatomic, strong) STSinaCellContentView *cellContentView;
@property (nonatomic, assign) BOOL horizontalScrollViewIsChanged;
@property (nonatomic, strong) UIScrollView *childScrollView;
@property (nonatomic, strong) STSinaSubTableViewController *subTableViewController;


@end

@implementation STSinaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Scott";
    [self st_setNavigationBarBackgroundAlpha:0];
    [self st_setNavigationBarTitleColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewNotification:) name:kSTSinaSubScrollViewDidScrollNotification object:nil];
    
    [self setupConfig];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinaCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SinaCellID"];
    }
    [cell.contentView removeFromSuperview];
    [cell addSubview:self.cellContentView];
    if (self.childViewControllers.count > 0) {
        self.subTableViewController = self.childViewControllers[0];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.toolBar;
}

#pragma mark - UITableViewDelegate


- (void)subScrollViewNotification:(NSNotification *)notifi {
    // 有的时候明明已经滚动过来了  但是这个childScrollView却还是上一个的
    if (!self.horizontalScrollViewIsChanged) {
        self.childScrollView = notifi.userInfo[kSTSinaSubTableViewControllerScrollViewKey];
    }
    
    CGFloat offsetHeight = kSinaHeaderViewHeight - STNaviBarHeight - STStatusBarHeight;
    
    if (self.tableView.contentOffset.y < offsetHeight) {
        self.childScrollView.contentOffset = CGPointZero;
    }else{
        self.tableView.contentOffset = CGPointMake(0, offsetHeight);
    }
}

- (void)setupConfig {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollsToTop = NO;
    self.tableView.rowHeight = kScreenHeight - kSinaToolsBarHeight - STStatusBarHeight - STNaviBarHeight;
    self.tableView.sectionHeaderHeight = kSinaToolsBarHeight;
    self.tableView.tableHeaderView = [self headerView];
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.horizontalScrollViewIsChanged) {
        self.horizontalScrollViewIsChanged = NO;
    }
    
    CGFloat offsetHeight = kSinaHeaderViewHeight - STNaviBarHeight - STStatusBarHeight;
    if (self.childScrollView && self.childScrollView.contentOffset.y > 0 && self.childScrollView.contentOffset.y != offsetHeight) {
        scrollView.contentOffset = CGPointMake(0, offsetHeight);
    }else if(scrollView.contentOffset.y < offsetHeight){
        [[NSNotificationCenter defaultCenter] postNotificationName:kSTSinaSubScrollViewDidScrollNotification object:nil userInfo:nil];
    }
    
    CGFloat scrollViewOffsetY = scrollView.contentOffset.y;

    if (scrollViewOffsetY <= 0) {
        CGFloat totalOffset = kSinaHeaderViewHeight - scrollViewOffsetY;
        CGFloat f = totalOffset / kSinaHeaderViewHeight;
        CGFloat height = totalOffset;
        CGFloat x = -(kScreenWidth * (f - 1))/2.0;
        CGFloat y = scrollViewOffsetY;
        CGFloat width = kScreenWidth * f;
        self.headerView.imageView.frame = CGRectMake(x, y, width, height);
    }
    
    // 0    0
    // 186  1
    CGFloat alpha = MIN(scrollViewOffsetY / offsetHeight, 1.0);
    [self st_setNavigationBarBackgroundAlpha:alpha];
    
    if (self.subTableViewController) {
        UIColor *color = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
        [self.subTableViewController st_setNavigationBarTitleColor:color];
    }
}

- (STSinaHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [STSinaHeaderView sinaHeaderView];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kSinaHeaderViewHeight);
    }
    return _headerView;
}

- (STSinaCellContentView *)cellContentView {
    if (_cellContentView == nil) {
        CGFloat height = kScreenHeight - STStatusBarHeight - STNaviBarHeight - kSinaToolsBarHeight;
        _cellContentView = [[STSinaCellContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) superViewController:self titleArrary:self.toolBar.segmentControl.sectionTitles];
        @weakify(self);
        _cellContentView.scrollViewDidScrollBlock = ^(NSInteger index){
            @strongify(self);
            if([self.childViewControllers[index] isKindOfClass:[STSinaSubTableViewController class]]){
                self.subTableViewController = self.childViewControllers[index];
                self.toolBar.segmentControl.selectedSegmentIndex = index;
                self.horizontalScrollViewIsChanged = YES;
                self.childScrollView = self.subTableViewController.scrollView;
            }
        };
    }
    return _cellContentView;
}

- (STSinaToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[STSinaToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSinaToolsBarHeight)];
        @weakify(self);
        [_toolBar.segmentControl setIndexChangeBlock:^(NSInteger index) {
            @strongify(self);
            self.cellContentView.scrollView.contentOffset = CGPointMake(kScreenWidth * index, 0);
            if([self.childViewControllers[index] isKindOfClass:[STSinaSubTableViewController class]]){
                self.subTableViewController = self.childViewControllers[index];
                self.childScrollView = self.subTableViewController.scrollView;
                self.horizontalScrollViewIsChanged = YES;
            }
        }];
    }
    return _toolBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
