//
//  STCustomViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STCustomViewController.h"
#import "Macro.h"
#import "STProfileViewController.h"

@interface STCustomViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation STCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.navBar aboveSubview:self.tableView];
    self.navItem.title = @"自定义导航栏";
}

#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *customCellID = @"customCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }

    NSString *str = nil;
    switch (indexPath.row) {
        case 0:
            str = @"Scott主页";
            break;
            
        default:
            break;
    }
    cell.textLabel.text = str;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            STProfileViewController *customNavBarVC = [STProfileViewController new];
            [self.navigationController pushViewController:customNavBarVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect rect = CGRectMake(0, STStatusBarHeight + STNaviBarHeight, kScreenWidth, kScreenHeight - STStatusBarHeight - STNaviBarHeight - 49);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
