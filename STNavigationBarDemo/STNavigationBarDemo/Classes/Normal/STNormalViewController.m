//
//  NormalViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STNormalViewController.h"
#import "Macro.h"
#import "STAntForestController.h"
#import "STQQZoneController.h"
#import "STZhihuController.h"
#import "STSinaController.h"
#import "STViewController.h"

@interface STNormalViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;


@end

@implementation STNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"普通";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = nil;
    
    switch (indexPath.row) {
        case 0:{    // 蚂蚁森林
            controller = [STAntForestController new];
        }
            break;
        case 1:{    // QQ空间
            controller = [STQQZoneController new];
        }
            break;
        case 2:{    // 知乎日报
            controller = [STZhihuController new];
        }
            break;
        case 3:{    // 新浪微博个人主页
            controller = [STSinaController new];
        }
            break;
            
        default:
            break;
    }
    
    if (controller == nil) { return;}
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = @[@"蚂蚁森林",@"QQ空间",@"知乎日报",@"新浪微博个人主页"];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect rect = CGRectMake(0, STNaviBarHeight+STStatusBarHeight, kScreenWidth, kScreenHeight-STNaviBarHeight-STTabBarHeight-STStatusBarHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
