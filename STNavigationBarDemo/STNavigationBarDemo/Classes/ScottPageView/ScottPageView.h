//
//  ScottPageView.h
//  ScottPageView
//
//  Created by Scott_Mr on 16/4/7.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSInteger index);

@interface ScottPageView : UIView

#pragma mark - 属性
/**
 *  分页控件，默认显示在底部居中
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  图片描述控件，默认在底部，黑色透明背景，白色字体居中显示
 */
@property (nonatomic, strong) UILabel *descLabel;

/**
 *  轮播的图片数组，可以是图片，也可以是网络图片路径
 */
@property (nonatomic, strong) NSArray *imageArr;

/**
 * 设置轮播图片的类型，默认为UIViewContentModeScaleToFill
 */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/**
 *  图片描述的字符串数组，应该与图片顺序相对应
 */
@property (nonatomic, strong) NSArray *describeArray;

/**
 *  每一页停留时间，默认是5s，至少1s
 */
@property (nonatomic, assign) NSTimeInterval time;

/**
 *  点击图片后要执行的操作，会返回图片在数组中的索引
 */
@property (nonatomic, copy) ClickBlock imageClickBlock;

/**
 *  构造方法
 *
 *  @param imageArr 图片数组
 *  @param descArr  图片描述数组
 *  @param clickBlock   处理图片点击
 *
 */
- (instancetype)initWithImageArr:(NSArray *)imageArr;
- (instancetype)initWithImageArr:(NSArray *)imageArr andDescArr:(NSArray *)descArr;
- (instancetype)initWithImageArr:(NSArray *)imageArr andImageClickBlock:(ClickBlock)clickBlock;

+ (instancetype)pageViewWithImageArr:(NSArray *)imageArr;
+ (instancetype)pageViewWithImageArr:(NSArray *)imageArr andDescArr:(NSArray *)descArr;
+ (instancetype)pageViewWithImageArr:(NSArray *)imageArr andImageClickBlock:(ClickBlock)clickBlock;

#pragma mark - 方法
/**  设置分页控件的图片 */
- (void)setPageImage:(UIImage *)pageImage andCurrentImage:(UIImage *)currentImage;
// 清理图片缓存
- (void)clearDiskCache;
// 开启定时器
- (void)startTimer;
// 关闭定时器
- (void)stopTimer;

@end
