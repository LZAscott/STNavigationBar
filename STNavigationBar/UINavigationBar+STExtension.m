//
//  UINavigationBar+STExtension.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "UINavigationBar+STExtension.h"
#import <objc/message.h>

static char kSTBackgroundViewKey;
static char kSTCustomBarBackgroundViewKey;

@implementation UINavigationBar (STExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(setTitleTextAttributes:));
        Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(@"st_setTitleTextAttributes:"));
        method_exchangeImplementations(originMethod, swizzledMethod);
    });
}

// 设置导航栏标题字体大小
- (void)st_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    NSMutableDictionary<NSString *,id> *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    if (newTitleTextAttributes == nil) {
        return;
    }
    
    NSDictionary<NSString *,id> *originTitleTextAttributes = self.titleTextAttributes;
    if (originTitleTextAttributes == nil) {
        [self st_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    
    __block UIColor *titleColor;
    [originTitleTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqual:NSForegroundColorAttributeName]) {
            titleColor = (UIColor *)obj;
            *stop = YES;
        }
    }];
    
    if (titleColor == nil) {
        [self st_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    
    if (newTitleTextAttributes[NSForegroundColorAttributeName] == nil) {
        newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    }
    [self st_setTitleTextAttributes:newTitleTextAttributes];
}


// 设置背景view
- (void)st_setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, &kSTBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 获取背景view
- (UIView *)st_backgroundView {
    return objc_getAssociatedObject(self, &kSTBackgroundViewKey);
}

// 设置自定义导航栏背景view
- (void)st_setCustomBarBackgroundView:(UIView *)customBackgroundView {
    objc_setAssociatedObject(self, &kSTCustomBarBackgroundViewKey, customBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 获取自定义导航栏背景view
- (UIView *)st_customBarBackgroundView {
    return objc_getAssociatedObject(self, &kSTCustomBarBackgroundViewKey);
}


// 设置背景color
- (void)st_setBackgroundColor:(UIColor *)color {
    if (self.st_backgroundView == nil) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        backgroundView.userInteractionEnabled = NO;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self st_setBackgroundView:backgroundView];
        [self.subviews.firstObject insertSubview:self.st_backgroundView atIndex:0];
    }
    
    self.st_backgroundView.backgroundColor = color;
}

// 获取背景color
- (UIColor *)st_backgroundColor {
    if (self.st_backgroundView == nil) {
        return nil;
    }
    return self.st_backgroundView.backgroundColor;
}

- (void)st_setCustomBarBackgroundColor:(UIColor *)color {
    if (self.st_customBarBackgroundView == nil) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        backgroundView.userInteractionEnabled = NO;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self st_setCustomBarBackgroundView:backgroundView];
        [self.subviews.firstObject insertSubview:self.st_customBarBackgroundView atIndex:0];
    }
    self.st_customBarBackgroundView.backgroundColor = color;
}

- (UIColor *)st_customBarBackgroundColor {
    if (self.st_customBarBackgroundView == nil) {
        return nil;
    }
    return self.st_customBarBackgroundView.backgroundColor;
}


// 设置背景alpha
- (void)st_setBackgroundAlpha:(CGFloat)alpha {
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
}
// 获取背景alpha
- (CGFloat)st_backgroundAlpha {
    UIView *barBackgroundView = self.subviews.firstObject;
    return barBackgroundView.alpha;
}

@end
