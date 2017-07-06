//
//  STZhihuController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/30.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STZhihuController.h"
#import "STNavigationBar.h"
#import "ScottPageView.h"
#import "AppDelegate.h"
#import "STViewController.h"

static CGFloat kBannerHeight = 180;

@interface STZhihuController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ScottPageView *pageView;
@property (nonatomic, strong) NSArray *picsArr;


@end

@implementation STZhihuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"知乎日报";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.pageView];
    [self st_setNavigationBarBackgroundAlpha:0];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kBannerHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kBannerHeight);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < (- kBannerHeight)) {  // 往下滑动
        CGRect originFrame = self.pageView.frame;
        originFrame.origin.y = offsetY;
        originFrame.size.height = -offsetY;
        self.pageView.frame = originFrame;
        
        [self.view setNeedsLayout];
    }

    // -180   0
    // -100   1
    CGFloat alpha = MIN((kBannerHeight + offsetY) / 80, 1.0);
    
    [self st_setNavigationBarBackgroundAlpha:alpha];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect originFrame = self.pageView.pageControl.frame;
    originFrame.origin.y = CGRectGetHeight(self.pageView.frame) - 30;
    self.pageView.pageControl.frame = originFrame;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"zhihucell";
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

- (NSArray *)picsArr {
    if (!_picsArr) {
        _picsArr = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"p1.jpg"], @"https://file27.mafengwo.net/M00/52/F2/wKgB6lO_PTyAKKPBACID2dURuk410.jpeg", @"https://file27.mafengwo.net/M00/B2/12/wKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg",[UIImage imageNamed:@"p2.jpg"], nil];
    }
    return _picsArr;
}

- (ScottPageView *)pageView {
    if (_pageView == nil) {
        _pageView = [ScottPageView pageViewWithImageArr:self.picsArr andImageClickBlock:^(NSInteger index) {
            NSLog(@"点击代码创建的第%ld张图片",index+1);
        }];
        _pageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        NSMutableArray *desArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<self.picsArr.count; i++) {
            NSString *tempDesc = [NSString stringWithFormat:@"这是第%ld张图片描述",i+1];
            [desArr addObject:tempDesc];
        }

        _pageView.describeArray = desArr;
        _pageView.frame = CGRectMake(0, -kBannerHeight, kScreenWidth, kBannerHeight);
        _pageView.time = 1;
    }
    return _pageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
