//
//  STNaviBar.m
//  STNavigationBarDemo
//
//  Created by bopeng on 2017/9/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STNaviBar.h"
#import "Macro.h"

@implementation STNaviBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
                subview.frame = self.bounds;
            }
            if ([NSStringFromClass([subview class]) containsString:@"BarContentView"]) {
                CGFloat y = kDevice_iPhoneX ? 44 : 20;
                CGFloat height = self.bounds.size.height - y;
                subview.frame = CGRectMake(0, y, self.bounds.size.width, height);
            }
        }
    }
}

@end
