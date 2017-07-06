//
//  STCustomTableView.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STCustomTableView.h"

@interface STCustomTableView ()<UIGestureRecognizerDelegate>

@end

@implementation STCustomTableView

//底层tableView实现这个UIGestureRecognizerDelegate的方法，从而可以接收并响应上层tabelView的滑动手势，otherGestureRecognizer就是它上层View也持有的Gesture，这里在它上层的有scrollView和顶层tableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    // 如果其他手势的view不存在就不响应
    if (otherGestureRecognizer.view == nil) {
        return NO;
    }
    
    // 如果其他手势的view是UIScrollView的，不响应 (isMemberOfClass：判断是否是UIScrollView的实例类)
    if ([otherGestureRecognizer.view isMemberOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    // 如果其他手势是UICollectionView或者UITableView的pan手势，响应 (isKindOfClass:判断是否是UIScrollView的实例类或者子类)
    BOOL isPan = [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    if (isPan && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    
    return NO;
}

@end
