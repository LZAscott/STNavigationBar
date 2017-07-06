//
//  STSinaCellContentView.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSinaCellContentView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) void(^scrollViewDidScrollBlock)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame
          superViewController:(UIViewController *)viewController
               titleArrary:(NSArray *)arr;

@end
