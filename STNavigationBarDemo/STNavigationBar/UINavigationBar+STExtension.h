//
//  UINavigationBar+STExtension.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (STExtension)


// 设置背景view
- (void)st_setBackgroundView:(UIView *)backgroundView;
// 获取背景view
- (UIView *)st_backgroundView;

// 设置自定义导航栏背景view
- (void)st_setCustomBarBackgroundView:(UIView *)customBackgroundView;
// 获取自定义导航栏背景view
- (UIView *)st_customBarBackgroundView;


// 设置背景color
- (void)st_setBackgroundColor:(UIColor *)color;
// 获取背景color
- (UIColor *)st_backgroundColor;

// 设置自定义导航栏背景color
- (void)st_setCustomBarBackgroundColor:(UIColor *)color;
// 获取自定义导航栏背景color
- (UIColor *)st_customBarBackgroundColor;


// 设置背景alpha
- (void)st_setBackgroundAlpha:(CGFloat)alpha;
// 获取背景alpha
- (CGFloat)st_backgroundAlpha;

@end
