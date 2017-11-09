//
//  STBaseViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STBaseViewController.h"
#import "STNavigationBar.h"
#import "Macro.h"
#import "STNaviBar.h"

@interface STBaseViewController ()

@end

@implementation STBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupCustomBar];
}

- (void)setupCustomBar {
    [self st_setCustomNavigationBar:self.navBar];
    
    [self.view addSubview:self.navBar];
    
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = STMainNavBarColor;
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navBar.tintColor = [UIColor whiteColor];
}

- (UIView *)overlay {
    if (_overlay == nil) {
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, STStatusBarHeight + STNaviBarHeight)];
        _overlay.userInteractionEnabled = NO;
        _overlay.backgroundColor = STMainNavBarColor;
        _overlay.alpha = 0;
        _overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _overlay;
}

- (UINavigationBar *)navBar {
    if (_navBar == nil) {
        _navBar = [[STNaviBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, STNaviBarHeight+STStatusBarHeight)];
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (_navItem == nil) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
