//
//  UIColor+STExtension.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/29.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (STExtension)

// 设置导航栏整体背景颜色
+ (void)st_setDefaultNavigationBarBarTintColor:(UIColor *)color;
+ (UIColor *)st_defaultNavigationBarBarTintColor;

// 设置导航栏左右控件颜色
+ (void)st_setDefaultNavigationBarTintColor:(UIColor *)color;
+ (UIColor *)st_defaultNavigationBarTintColor;

// 设置导航栏标题颜色
+ (void)st_setDefaultNavigationBarTitleColor:(UIColor *)color;
+ (UIColor *)st_defaultNavigationBarTitleColor;

// 设置状态栏样式
+ (void)st_setDefaultStatusBarStyle:(UIStatusBarStyle)style;
+ (UIStatusBarStyle)st_defaultStatusBarStyle;

+ (CGFloat)st_defaultNavigationBarBackgroundAlpha;

+ (UIColor *)st_fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;
+ (CGFloat)st_fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent;


@end
