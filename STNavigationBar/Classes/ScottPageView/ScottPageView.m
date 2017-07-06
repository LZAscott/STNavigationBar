//
//  ScottPageView.m
//  ScottPageView
//
//  Created by Scott_Mr on 16/4/7.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "ScottPageView.h"

#define DEFAULTTIME 5
static NSString *cachePath = @"ScottPage";

typedef NS_ENUM(NSInteger, Direction) {
    DirectionNone = 1 << 0,
    DirectionLeft = 1 << 1,
    DirectionRight = 1 << 2
};


@interface ScottPageView ()<UIScrollViewDelegate>

// 轮播的图片数组
@property (nonatomic, strong) NSMutableArray *images;
// 下载的图片字典
@property (nonatomic, strong) NSMutableDictionary *imageDic;
// 下载图片的操作
@property (nonatomic, strong) NSMutableDictionary *operationDic;
// 滚动方向
@property (nonatomic, assign) Direction direction;
// 提示信息
@property (nonatomic, strong) UILabel *noticeLabel;
// 显示的imageView
@property (nonatomic, strong) UIImageView *currentImageView;
// 即将要显示的imageView
@property (nonatomic, strong) UIImageView *nextImageView;
// 当前显示的索引
@property (nonatomic, assign) NSInteger currentIndex;
// 将要显示的索引
@property (nonatomic, assign) NSInteger nextIndex;
// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 任务队列
@property (nonatomic, strong) NSOperationQueue *queue;

@end


@implementation ScottPageView

#pragma mark - 初始化方法
// 创建用来缓存图片的文件夹
+ (void)initialize {
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:cachePath];
    BOOL isDir = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cache isDirectory:&isDir];
    if (!isExists || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - frame相关
- (CGFloat)height {
    return self.scrollView.frame.size.height;
}

- (CGFloat)width {
    return self.scrollView.frame.size.width;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)imageDic {
    return _imageDic ? : (_imageDic = @{}.mutableCopy);
}

- (NSMutableDictionary *)operationDic {
    return _operationDic ? : (_operationDic = @{}.mutableCopy);
}

- (NSOperationQueue *)queue {
    return _queue ? : (_queue = [[NSOperationQueue alloc] init]);
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"没有图片哦，赶快去设置吧！";
        _noticeLabel.textColor = [UIColor blackColor];
        _noticeLabel.font = [UIFont systemFontOfSize:20];
        [_noticeLabel sizeToFit];
        [self addSubview:_noticeLabel];
    }
    return _noticeLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        _bannerImageViewContentMode = UIViewContentModeScaleToFill;
        
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.userInteractionEnabled = YES;
        [_currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
        [_scrollView addSubview:_currentImageView];
        
        _nextImageView = [[UIImageView alloc] init];
        [_scrollView addSubview:_nextImageView];
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:13];
        _descLabel.hidden = YES;
        [self addSubview:_descLabel];
        
    }
    return _descLabel;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

#pragma mark - 构造方法
- (instancetype)initWithImageArr:(NSArray *)imageArr {
    return [self initWithImageArr:imageArr andImageClickBlock:nil];
}

- (instancetype)initWithImageArr:(NSArray *)imageArr andDescArr:(NSArray *)descArr {
    if (self = [self initWithImageArr:imageArr]) {
        self.describeArray = descArr;
    }
    return self;
}

- (instancetype)initWithImageArr:(NSArray *)imageArr andImageClickBlock:(ClickBlock)clickBlock {
    if (self = [super init]) {
        self.imageArr = imageArr;
        self.imageClickBlock = clickBlock;
    }
    return self;
}

+ (instancetype)pageViewWithImageArr:(NSArray *)imageArr {
    return  [self pageViewWithImageArr:imageArr andImageClickBlock:nil];
}

+ (instancetype)pageViewWithImageArr:(NSArray *)imageArr andDescArr:(NSArray *)descArr {
    return [[self alloc] initWithImageArr:imageArr andDescArr:descArr];
}

+ (instancetype)pageViewWithImageArr:(NSArray *)imageArr andImageClickBlock:(ClickBlock)clickBlock {
    return [[self alloc] initWithImageArr:imageArr andImageClickBlock:clickBlock];
}



#pragma mark - 设置控件的frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.scrollView.frame = self.bounds;
    self.descLabel.frame = CGRectMake(0, self.height - 20, self.width, 20);
    self.pageControl.center = CGPointMake(self.width * 0.5, self.height - 10);
    self.noticeLabel.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
    _scrollView.contentOffset = CGPointMake(self.width, 0);
    _currentImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    [self setScrollViewContentSize];
}

#pragma mark - 设置滚动方向
- (void)setDirection:(Direction)direction {
    if (_direction == direction) return;
    _direction = direction;
    if (_direction == DirectionNone) return;
    
    if (_direction == DirectionRight) { // 如果是向右滚动
        self.nextImageView.frame = CGRectMake(0, 0, self.width, self.height);
        self.nextIndex = self.currentIndex - 1;
        if (self.nextIndex < 0) self.nextIndex = _images.count - 1;
        
    }else if (_direction == DirectionLeft){ // 如果是向左边滚动
        self.nextImageView.frame = CGRectMake(CGRectGetMaxX(_currentImageView.frame), 0, self.width, self.height);
        self.nextIndex = (self.currentIndex + 1) % _images.count;
    }
    self.nextImageView.image = self.images[self.nextIndex];
    if (self.images.count <= 1) {
        [self pauseScroll];
    }
}

#pragma mark - 设置图片数组
- (void)setImageArr:(NSArray *)imageArr {
    //    if (!imageArr.count) return;
    if (imageArr.count == 0) return;
    
    self.noticeLabel.hidden = YES;
    _imageArr = imageArr;
    _images = [NSMutableArray array];
    for (int i=0; i<imageArr.count; i++) {
        if ([imageArr[i] isKindOfClass:[UIImage class]]) {  // 如果是本地图片
            [_images addObject:imageArr[i]];
        }else if([imageArr[i] isKindOfClass:[NSString class]]){ // 如果是网络地址
            [_images addObject:[UIImage imageNamed:@"background_image_default"]];
            [self downloadImages:i];
        }
    }
    self.currentImageView.image = _images.firstObject;
    self.currentIndex = 0;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = _images.count;
    [self setScrollViewContentSize];
}

#pragma mark - 设置图片描述数组
- (void)setDescribeArray:(NSArray *)describeArray {
    _describeArray = describeArray;
    
    // 如果描述的个数与图片个数不一致，则补空字符串
    if (describeArray && describeArray.count > 0) {
        if (describeArray.count < _images.count) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:describeArray];
            for (NSInteger i=describeArray.count; i<_images.count; i++) {
                [tempArr addObject:@""];
            }
            _describeArray = tempArr;
        }
        self.descLabel.hidden = NO;
        _descLabel.text = [_describeArray firstObject];
    }
}

#pragma mark - 设置图片模式
- (void)setBannerImageViewContentMode:(UIViewContentMode)bannerImageViewContentMode {
    if (self.currentImageView) {
        self.currentImageView.contentMode = self.bannerImageViewContentMode;
    }
    if (self.nextImageView) {
        self.nextImageView.contentMode = self.bannerImageViewContentMode;
    }
}

#pragma mark - 设置scrollView的contentSize
- (void)setScrollViewContentSize {
    if (_images.count > 1) {
        self.scrollView.contentSize = CGSizeMake(self.width * 3, 0);
        [self startTimer];
    } else {
        self.scrollView.contentSize = CGSizeZero;
    }
}

#pragma mark - 设置pageControl的图片
- (void)setPageImage:(UIImage *)pageImage andCurrentImage:(UIImage *)currentImage {
    if (!pageImage || !currentImage) return;
    
    [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [self.pageControl setValue:pageImage forKey:@"_pageImage"];
}

#pragma mark - 设置定时器时间
- (void)setTime:(NSTimeInterval)time {
    _time = time;
    [self startTimer];
}

#pragma mark - 定时器相关操作
// 开启定时器
- (void)startTimer {
    // 如果只有一张，直接放回，不需要开启定时器
    if (_images.count <= 1) return;
    
    // 如果定时器已经开启，则先停止再开启
    if (self.timer) [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:_time < 1 ? DEFAULTTIME : _time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 关闭定时器
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// 下一页
- (void)nextPage {
    [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    [self setNeedsLayout];
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    if (self.currentImageView) {
        self.currentImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    }
}

#pragma mark - 点击图片
- (void)imageClick {
    if (self.imageClickBlock) {
        self.imageClickBlock(self.currentIndex);
    }
}

#pragma mark - 下载网络图片
- (void)downloadImages:(int)index {
    NSString *key = _imageArr[index];
    UIImage *image = self.imageDic[key];
    if (image) {
        _images[index] = image;
        return;
    }
    
    // 从沙盒取出图片
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:cachePath];
    NSString *path = [cache stringByAppendingPathComponent:[key lastPathComponent]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        image = [UIImage imageWithData:data];
        _images[index] = image;
        [_imageDic setObject:image forKey:key];
        return;
    }
    
    // 下载图片
    NSBlockOperation *download = self.operationDic[key];
    if (download) return;
    // 创建一个下载操作
    download = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:key];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (!data) return;
        UIImage *image = [UIImage imageWithData:data];
        // 取到的data有可能不是图片
        if (image) {
            [self.imageDic setObject:image forKey:key];
            self.images[index] = image;
            // 如果下载的图片为当前需要显示的图片，直接到主线程给imageView赋值，否则需要等到下一轮才会显示
            if (_currentIndex == index) {
                [_currentImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            }
            [data writeToFile:path atomically:YES];
        }
        [self.operationDic removeObjectForKey:key];
    }];
    
    [self.queue addOperation:download];
    [self.operationDic setObject:download forKey:key];
}

#pragma mark - 清空沙盒中的图片缓存
- (void)clearDiskCache {
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:cachePath];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *fileName in contents) {
        [[NSFileManager defaultManager] removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:NULL];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offX = scrollView.contentOffset.x;
    self.direction = offX > self.width ? DirectionLeft : offX < self.width ? DirectionRight : DirectionNone;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pauseScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self pauseScroll];
}

- (void)pauseScroll {
    // 等于1表示没有滚动
    if (self.scrollView.contentOffset.x / self.width == 1) return;
    
    self.currentIndex = self.nextIndex;
    self.pageControl.currentPage = self.currentIndex;
    self.currentImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.descLabel.text = self.describeArray[self.currentIndex];
    self.currentImageView.image = self.nextImageView.image;
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
}

@end
