//
//  Macro.h
//  STNavigationBarDemo
//
//  Created by bopeng on 2017/7/7.
//  Copyright © 2017年 Scott. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define STMainNavBarColor [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]
#define STMainViewColor [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1]
#define STNaviBarTintColor [UIColor whiteColor]
#define STNaviBarTitleColor [UIColor whiteColor]

#define STStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define STNaviBarHeight   CGRectGetHeight(self.navigationController.navigationBar.frame)
#define STTabBarHeight    CGRectGetHeight(self.tabBarController.tabBar.frame)

#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height


#endif /* Macro_h */
