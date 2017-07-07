//
//  STScrollView.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/3.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STScrollView.h"
#import "STNavigationBar.h"

@interface STScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation STScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:[STFullscreenPopGestureRecognizerDelegate class]]) {
            return YES;
        }
    }
    return NO;
}

@end
