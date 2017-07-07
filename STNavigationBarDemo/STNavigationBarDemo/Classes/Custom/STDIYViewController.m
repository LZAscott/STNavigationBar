//
//  STDIYViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/3.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STDIYViewController.h"
#import "STNavigationBar.h"
#import "Macro.h"

@interface STDIYViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation STDIYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavItem];
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
    
    // 禁止右滑
    [self st_setInteractivePopDisabled:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, STStatusBarHeight + STNaviBarHeight, kScreenWidth, kScreenHeight - STStatusBarHeight - STNaviBarHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"diyCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *str = [NSString stringWithFormat:@"STNavigationBar --- %ld",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (void)setupNavItem{
    self.navItem.title = @"禁止右滑返回";
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareClick)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick)];
    self.navItem.rightBarButtonItems = @[shareItem, saveItem];
}

- (void)shareClick {
    NSLog(@"点击了分享");
}

- (void)saveClick {
    NSLog(@"点击了保存");
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
