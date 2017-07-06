//
//  QQZoneController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/30.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STQQZoneController.h"
#import "AppDelegate.h"
#import "STNavigationBar.h"
#import "STQQZoneHeaderView.h"
#import "STViewController.h"

CGFloat kHeaderViewHeight = 300;

@interface STQQZoneController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) STQQZoneHeaderView *headerView;


@end

@implementation STQQZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QQ空间";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    
    [self st_setNavigationBarBackgroundAlpha:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat scrollMax = (kHeaderViewHeight - STNaviBarHeight - STStatusBarHeight - 20);
    
    if (offsetY > scrollMax) {
        [self st_setNavigationBarBackgroundAlpha:1];
        [self st_setNavigationBarTintColor:[UIColor darkGrayColor]];
        [self st_setNavigationBarTitleColor:[UIColor darkGrayColor]];
        [self st_setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [self st_setNavigationBarBackgroundAlpha:0];
        [self st_setNavigationBarTintColor:[UIColor whiteColor]];
        [self st_setNavigationBarTitleColor:[UIColor whiteColor]];
        [self st_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"qqzonecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"STNavigationBar-----%ld",indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    STViewController *viewController = [STViewController new];
    viewController.title = [NSString stringWithFormat:@"STNavigationBar%ld", indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [STQQZoneHeaderView zoneHeaderView];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight);
    }
    return _headerView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageView.image = [UIImage imageNamed:@"qqzone"];
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
