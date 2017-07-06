//
//  STProfileViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/2.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STProfileViewController.h"
#import "STNavigationBar.h"
#import "AppDelegate.h"
#import "STDIYViewController.h"

static CGFloat kHeaderViewHeight = 250.0;

@interface STProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation STProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self headerView];
    
    [self.view insertSubview:self.navBar aboveSubview:self.tableView];
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navItem.title = @"个人中心";
    
    
    // 设置导航栏颜色
    [self st_setNavigationBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    // 设置导航栏透明度
    [self st_setNavigationBarBackgroundAlpha:0];
    
    // 设置导航栏按钮颜色
    [self st_setNavigationBarTintColor:[UIColor whiteColor]];
    
    // 设置标题文字颜色
    [self st_setNavigationBarTitleColor:[UIColor whiteColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 128.0) {
        CGFloat alpha =  (offsetY - 128) / 64.0;
        [self st_setNavigationBarBackgroundAlpha:alpha];
        [self st_setNavigationBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self st_setNavigationBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self st_setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [self st_setNavigationBarBackgroundAlpha:0];
        [self st_setNavigationBarTintColor:[UIColor whiteColor]];
        [self st_setNavigationBarTitleColor:[UIColor whiteColor]];
        [self st_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"profileCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *str = [NSString stringWithFormat:@"STNavigationBar --- %ld",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    STDIYViewController *diyVC = [[STDIYViewController alloc] init];
    [self.navigationController pushViewController:diyVC animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor orangeColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
        imageView.bounds = CGRectMake(0, 0, 100, 100);
        imageView.center = _headerView.center;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.masksToBounds = YES;
        [_headerView addSubview:imageView];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
