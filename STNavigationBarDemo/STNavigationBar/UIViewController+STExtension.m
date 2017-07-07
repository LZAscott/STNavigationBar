//
//  UIViewController+STExtension.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "UIViewController+STExtension.h"
#import "STNavigationBar.h"
#import <objc/message.h>

static char kSTPushToCurrentControllerKey;
static char kSTPushToNextControllerKey;
static char kSTNavigationBarTintColorKey;
static char kSTNavigationBarBarTintColorKey;
static char kSTNavigationBarBackgroundAlphaKey;
static char kSTNavigationBarTitleColorKey;
static char kSTStatusBarStyleKey;
static char kSTCustomNavigationBarKey;

@implementation UIViewController (STExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[3] = {
            @selector(viewWillAppear:),
            @selector(viewWillDisappear:),
            @selector(viewDidAppear:)
        };
        
        for (int i=0; i<3; i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *needSelectorStr = [NSString stringWithFormat:@"st_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzleMethod = class_getInstanceMethod(self, NSSelectorFromString(needSelectorStr));
            method_exchangeImplementations(originMethod, swizzleMethod);
        }
    });
}

- (void)st_viewWillAppear:(BOOL)animated {
    [self st_setPushToNextControllerFinished:NO];
    [self.navigationController st_setNeedsNavigationBarUpdateForTintColor:[self st_navigationBarTintColor]];
    [self.navigationController st_setNeedsNavigationBarUpdateForTitleColor:[self st_navigationBarTitleColor]];
    
    [self st_viewWillAppear:animated];
}

- (void)st_viewWillDisappear:(BOOL)animated {
    [self st_setPushToNextControllerFinished:YES];
    [self st_viewWillDisappear:animated];
}

- (void)st_viewDidAppear:(BOOL)animated {
    [self.navigationController st_setNeedsNavigationBarUpdateForBarTintColor:[self st_navigationBarBarTintColor]];
    [self.navigationController st_setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self st_navigationBarBackgroundAlpha]];
    [self.navigationController st_setNeedsNavigationBarUpdateForTintColor:[self st_navigationBarTintColor]];
    [self.navigationController st_setNeedsNavigationBarUpdateForTitleColor:[self st_navigationBarTitleColor]];

    [self st_viewDidAppear:animated];
}

- (void)st_setPushToCurrentControllerFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kSTPushToCurrentControllerKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)st_pushToCurrentControllerFinished {
    id isFinished = objc_getAssociatedObject(self, &kSTPushToCurrentControllerKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}

- (void)st_setPushToNextControllerFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kSTPushToNextControllerKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)st_pushToNextControllerFinished {
    id isFinished = objc_getAssociatedObject(self, &kSTPushToNextControllerKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}

// 设置当前控制器NavigationBar tintColor
- (void)st_setNavigationBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSTNavigationBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self st_customNavigationBar] isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *navBar = (UINavigationBar *)[self st_customNavigationBar];
        navBar.tintColor = color;
    }else{
        if ([self st_pushToNextControllerFinished] == NO) {
            [self.navigationController st_setNeedsNavigationBarUpdateForTintColor:color];
        }
    }
}

- (UIColor *)st_navigationBarTintColor {
    UIColor *color = objc_getAssociatedObject(self, &kSTNavigationBarTintColorKey);
    return (color != nil) ? color : [UIColor st_defaultNavigationBarTintColor];
}

// 设置当前控制器NavigationBar barTintColor
- (void)st_setNavigationBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSTNavigationBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self st_customNavigationBar] isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *navBar = (UINavigationBar *)[self st_customNavigationBar];
//        [navBar st_setBackgroundColor:color];
        [navBar st_setCustomBarBackgroundColor:color];
    }else{
        if ([self st_pushToNextControllerFinished] == NO && [self st_pushToCurrentControllerFinished] == YES) {
            [self.navigationController st_setNeedsNavigationBarUpdateForBarTintColor:color];
        }
    }
}

- (UIColor *)st_navigationBarBarTintColor {
    UIColor *color = objc_getAssociatedObject(self, &kSTNavigationBarBarTintColorKey);
    return (color != nil) ? color : [UIColor st_defaultNavigationBarBarTintColor];
}

// 设置当前控制器NavigationBar backgroundAlpha
- (void)st_setNavigationBarBackgroundAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, &kSTNavigationBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self st_customNavigationBar] isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *navBar = (UINavigationBar *)[self st_customNavigationBar];
        [navBar st_setBackgroundAlpha:alpha];
    }else{
        if ([self st_pushToNextControllerFinished] == NO && [self st_pushToCurrentControllerFinished] == YES) {
            [self.navigationController st_setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
        }
    }
}

- (CGFloat)st_navigationBarBackgroundAlpha {
    id alpha = objc_getAssociatedObject(self, &kSTNavigationBarBackgroundAlphaKey);
    return (alpha != nil) ? [alpha floatValue] : [UIColor st_defaultNavigationBarBackgroundAlpha];
}

// 设置当前控制器NavigationBar titleColor
- (void)st_setNavigationBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSTNavigationBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self st_customNavigationBar] isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *navBar = (UINavigationBar *)[self st_customNavigationBar];
        navBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    }else{
        if ([self st_pushToNextControllerFinished] == NO) {
            [self.navigationController st_setNeedsNavigationBarUpdateForTitleColor:color];
        }
    }
}

- (UIColor *)st_navigationBarTitleColor {
    UIColor *color = objc_getAssociatedObject(self, &kSTNavigationBarTitleColorKey);
    return (color != nil) ? color : [UIColor st_defaultNavigationBarTitleColor];
}

// 设置当前控制器StatusBar样式
- (void)st_setStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kSTStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)st_statusBarStyle {
    id style = objc_getAssociatedObject(self, &kSTStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : [UIColor st_defaultStatusBarStyle];
}

// 设置当前控制器自定义navigationBar
- (void)st_setCustomNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, &kSTCustomNavigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)st_customNavigationBar {
    UIView *navBar = objc_getAssociatedObject(self, &kSTCustomNavigationBarKey);
    return (navBar != nil) ? navBar : [UIView new];
}

- (BOOL)st_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)st_setInteractivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(st_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)st_interactivePopMaxAllowedInitialDistanceToLeftEdge {
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)st_setInteractivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance {
    SEL key = @selector(st_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
