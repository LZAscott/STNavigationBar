//
//  UIColor+STExtension.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/29.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "UIColor+STExtension.h"
#import <objc/message.h>

static char kSTDefaultBarTintColorKey;
static char kSTDefaultTintColorKey;
static char kSTDefaultTitleColorKey;
static char kSTDefaultStatusBarStyleKey;


@implementation UIColor (STExtension)

+ (void)st_setDefaultNavigationBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSTDefaultBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)st_defaultNavigationBarBarTintColor {
    UIColor *color = objc_getAssociatedObject(self, &kSTDefaultBarTintColorKey);
    return (color != nil) ? color : [UIColor whiteColor];
}


+ (void)st_setDefaultNavigationBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSTDefaultTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)st_defaultNavigationBarTintColor {
    UIColor *color = objc_getAssociatedObject(self, &kSTDefaultTintColorKey);
    return (color != nil) ? color : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}

+ (void)st_setDefaultNavigationBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSTDefaultTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)st_defaultNavigationBarTitleColor {
    UIColor *color = objc_getAssociatedObject(self, &kSTDefaultTitleColorKey);
    return (color != nil) ? color : [UIColor blackColor];
}

+ (CGFloat)st_defaultNavigationBarBackgroundAlpha {
    return 1.0;
}

+ (void)st_setDefaultStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kSTDefaultStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIStatusBarStyle)st_defaultStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kSTDefaultStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}

+ (UIColor *)st_fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

+ (CGFloat)st_fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent {
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}


@end
