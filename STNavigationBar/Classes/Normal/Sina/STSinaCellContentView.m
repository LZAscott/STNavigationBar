//
//  STSinaCellContentView.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STSinaCellContentView.h"
#import "STSinaSubTableViewController.h"
#import "AppDelegate.h"

@interface STSinaCellContentView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *superViewConter;



@end

@implementation STSinaCellContentView

- (instancetype)initWithFrame:(CGRect)frame superViewController:(UIViewController *)viewController titleArrary:(NSArray *)arr; {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.superViewConter = viewController;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setContentSize:CGSizeMake(kScreenWidth * arr.count, 0)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        
        for (int i=0; i<arr.count; i++) {
            STSinaSubTableViewController *tableVC = [[STSinaSubTableViewController alloc] init];
            [viewController addChildViewController:tableVC];
            
            tableVC.view.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, self.bounds.size.height);
            tableVC.title = arr[i];
            [_scrollView addSubview:tableVC.view];
            [tableVC didMoveToParentViewController:viewController];
        }
        [self addSubview:_scrollView];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreenWidth);
    !self.scrollViewDidScrollBlock ? : self.scrollViewDidScrollBlock(index);
}

@end
