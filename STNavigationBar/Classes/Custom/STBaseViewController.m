//
//  STBaseViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STBaseViewController.h"
#import "STNavigationBar.h"
#import "AppDelegate.h"

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.bounds), CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20);
}

- (UINavigationBar *)navBar {
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc] init];
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
