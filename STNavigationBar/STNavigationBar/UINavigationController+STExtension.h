//
//  UINavigationController+STExtension.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFullscreenPopGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@interface UINavigationController (STExtension)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *st_fullscreenPopGestureRecognizer;

- (void)st_setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)color;
- (void)st_setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)backgroundAplha;
- (void)st_setNeedsNavigationBarUpdateForTintColor:(UIColor *)color;
- (void)st_setNeedsNavigationBarUpdateForTitleColor:(UIColor *)color;
- (void)st_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress;

@end
