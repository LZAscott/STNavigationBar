//
//  STAntForestController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/29.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STAntForestController.h"
#import "Macro.h"
#import "STNavigationBar.h"
#import "STViewController.h"

// 图片高度
CGFloat STImageHeight = 480;

@interface STAntForestController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation STAntForestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蚂蚁森林";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(STImageHeight - (STNaviBarHeight + STStatusBarHeight), 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -STImageHeight);
    
    [self.tableView addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:UIBarButtonItemStyleDone target:self action:@selector(clickMore)];
    [self st_setNavigationBarBarTintColor:[UIColor whiteColor]];
    [self st_setNavigationBarBackgroundAlpha:0];
    
//    [self st_setInteractivePopMaxAllowedInitialDistanceToLeftEdge:40];
}

- (void)clickMore {
    NSLog(@"点击蚂蚁森林更多");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;

    if (offY > - STImageHeight) {   // 往上滑动
        CGFloat alpha = (offY  + STImageHeight) / (STNaviBarHeight + STStatusBarHeight);
        [self st_setNavigationBarBackgroundAlpha:alpha];
        
        if (alpha > 0.5) {
            [self st_setNavigationBarTintColor:[UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0]];
            [self st_setNavigationBarTitleColor:[UIColor blackColor]];
            [self st_setStatusBarStyle:UIStatusBarStyleDefault];
        }else{
            [self st_setNavigationBarTintColor:[UIColor whiteColor]];
            [self st_setNavigationBarTitleColor:[UIColor whiteColor]];
            [self st_setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }else{
        [self st_setNavigationBarBackgroundAlpha:0];
        [self st_setNavigationBarTintColor:[UIColor whiteColor]];
        [self st_setNavigationBarTitleColor:[UIColor whiteColor]];
        [self st_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    if (offY < -STImageHeight) {
        [scrollView setContentOffset:CGPointMake(0, -STImageHeight)];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"antforestcell";
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - STImageHeight, kScreenWidth, STImageHeight)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"mysl"];
    }
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
