//
//  STViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/30.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STViewController.h"
#import "STNavigationBar.h"
#import "STScrollView.h"
#import "Macro.h"

@interface STViewController ()

@property (nonatomic, strong) STScrollView *scrollView;
@property (nonatomic, strong) UILabel *noticeLabel;


@end

@implementation STViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"STViewController";
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.noticeLabel];
}

- (STScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[STScrollView alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, 100)];
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.contentSize = CGSizeMake(2000, 0);
    }
    return _scrollView;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, kScreenWidth - 20, 40)];
        _noticeLabel.numberOfLines = 2;
        _noticeLabel.text = @"全屏返回遇到UIScrollView的时候，往右滑动绿色view看看效果";
        _noticeLabel.font = [UIFont systemFontOfSize:13];
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noticeLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
