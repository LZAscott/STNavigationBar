//
//  STSinaToolBar.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STSinaToolBar.h"


@implementation STSinaToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSegmentControl];
    }
    return self;
}

- (void)setupSegmentControl {
    
    _segmentControl = [[HMSegmentedControl alloc] init];
    [_segmentControl setSectionTitles:@[@"主页",@"微博",@"相册"]];
    _segmentControl.backgroundColor = [UIColor whiteColor];
    [_segmentControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [_segmentControl setSegmentWidthStyle:HMSegmentedControlSegmentWidthStyleFixed];
    [_segmentControl setSelectionIndicatorColor:[UIColor redColor]];
    [_segmentControl setSelectionIndicatorHeight:2.0];
//    [_segmentControl setSelectionIndicatorEdgeInsets:UIEdgeInsetsMake(0, 10, -4, 20)];
    [_segmentControl setSelectedTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    
    _segmentControl.frame = self.bounds;
    [self addSubview:_segmentControl];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1)];

    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:lineView];
}

@end
