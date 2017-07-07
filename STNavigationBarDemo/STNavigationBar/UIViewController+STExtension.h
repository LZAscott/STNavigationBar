//
//  UIViewController+STExtension.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (STExtension)


- (void)st_setPushToCurrentControllerFinished:(BOOL)isFinished;
- (BOOL)st_pushToCurrentControllerFinished;

- (void)st_setPushToNextControllerFinished:(BOOL)isFinished;
- (BOOL)st_pushToNextControllerFinished;


// 设置当前控制器NavigationBar tintColor
- (void)st_setNavigationBarTintColor:(UIColor *)color;
- (UIColor *)st_navigationBarTintColor;

// 设置当前控制器NavigationBar barTintColor
- (void)st_setNavigationBarBarTintColor:(UIColor *)color;
- (UIColor *)st_navigationBarBarTintColor;

// 设置当前控制器NavigationBar backgroundAlpha
- (void)st_setNavigationBarBackgroundAlpha:(CGFloat)alpha;
- (CGFloat)st_navigationBarBackgroundAlpha;

// 设置当前控制器NavigationBar titleColor
- (void)st_setNavigationBarTitleColor:(UIColor *)color;
- (UIColor *)st_navigationBarTitleColor;

// 设置当前控制器StatusBar样式
- (void)st_setStatusBarStyle:(UIStatusBarStyle)style;
- (UIStatusBarStyle)st_statusBarStyle;

// 设置当前控制器自定义navigationBar
- (void)st_setCustomNavigationBar:(UINavigationBar *)navigationBar;

// 设置是否支持手势返回  YES:关闭   NO:开启
- (void)st_setInteractivePopDisabled:(BOOL)disabled;
- (BOOL)st_interactivePopDisabled;

// 设置手势返回的范围(从左侧开始)
- (void)st_setInteractivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance;
- (CGFloat)st_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
