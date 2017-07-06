//
//  UINavigationController+STExtension.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "UINavigationController+STExtension.h"
#import "STNavigationBar.h"
#import <objc/message.h>

@implementation STFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.st_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.st_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end



@implementation UINavigationController (STExtension)

static CGFloat STPopDuration = 0.12;
static int STPopDisplayCount = 0;
static CGFloat STPushDuration = 0.10;
static int STPushDisplayCount = 0;

- (CGFloat)st_popProgress {
    CGFloat all = 60 * STPopDuration;
    int current = MIN(all, STPopDisplayCount);
    return current / all;
}

- (CGFloat)st_pushProgress {
    CGFloat all = 60 * STPushDuration;
    int current = MIN(all, STPushDisplayCount);
    return current / all;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] st_statusBarStyle];
}

- (void)st_setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)color {
    [self.navigationBar st_setBackgroundColor:color];
}

- (void)st_setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)backgroundAplha {
    [self.navigationBar st_setBackgroundAlpha:backgroundAplha];
}

- (void)st_setNeedsNavigationBarUpdateForTintColor:(UIColor *)color {
    self.navigationBar.tintColor = color;
}

- (void)st_setNeedsNavigationBarUpdateForTitleColor:(UIColor *)color {
    NSDictionary *titleTextAttributes = [self.navigationBar titleTextAttributes];
    if (titleTextAttributes == nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
        return;
    }
    
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = color;
    self.navigationBar.titleTextAttributes = newTitleTextAttributes;
}

- (void)st_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    // 改变整体导航栏背景颜色
    UIColor *fromBarTintColor = [fromVC st_navigationBarBarTintColor];
    UIColor *toBarTintColor = [toVC st_navigationBarBarTintColor];
    UIColor *newBarTintColor = [UIColor st_fromColor:fromBarTintColor toColor:toBarTintColor percent:progress];
    [self st_setNeedsNavigationBarUpdateForBarTintColor:newBarTintColor];
    
    // 改变导航栏左右控件颜色
    UIColor *fromTintColor = [fromVC st_navigationBarTintColor];
    UIColor *toTintColor = [toVC st_navigationBarTintColor];
    UIColor *newTintColor = [UIColor st_fromColor:fromTintColor toColor:toTintColor percent:progress];
    [self st_setNeedsNavigationBarUpdateForTintColor:newTintColor];
    
    // 改变标题栏颜色
    UIColor *fromTitleColor = [fromVC st_navigationBarTitleColor];
    UIColor *toTitleColor = [toVC st_navigationBarTitleColor];
    UIColor *newTitleColor = [UIColor st_fromColor:fromTitleColor toColor:toTitleColor percent:progress];
    [self st_setNeedsNavigationBarUpdateForTitleColor:newTitleColor];
    
    // 改变整体导航栏透明度
    CGFloat fromBackgroundAlpha = [fromVC st_navigationBarBackgroundAlpha];
    CGFloat toBackgroundAlpha = [toVC st_navigationBarBackgroundAlpha];
    CGFloat newBackgroundAlpha = [UIColor st_fromAlpha:fromBackgroundAlpha toAlpha:toBackgroundAlpha percent:progress];
    [self st_setNeedsNavigationBarUpdateForBarBackgroundAlpha:newBackgroundAlpha];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL neddSwizzleSelectors[4] = {
            NSSelectorFromString(@"_updateInteractiveTransition:"),
            @selector(pushViewController:animated:),
            @selector(popToViewController:animated:),
            @selector(popToRootViewControllerAnimated:),
        };
        
        for (int i=0; i<4; i++) {
            SEL selector = neddSwizzleSelectors[i];
            NSString *newSelectorStr = [[NSString stringWithFormat:@"st_%@",NSStringFromSelector(selector)] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzleMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzleMethod);
        }
    });
}

- (nullable NSArray<__kindof UIViewController *> *)st_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(st_popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        STPopDisplayCount = 0;
    }];
    
    [CATransaction setAnimationDuration:STPopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self st_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return vcs;
}

- (nullable NSArray<__kindof UIViewController *> *)st_popToRootViewControllerAnimated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(st_popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        STPopDisplayCount = 0;
    }];
    
    [CATransaction setAnimationDuration:STPopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self st_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return vcs;
}

- (void)st_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(st_pushNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        STPushDisplayCount = 0;
        [viewController st_setPushToCurrentControllerFinished:YES];
    }];
    
    [CATransaction setAnimationDuration:STPushDuration];
    [CATransaction begin];
    
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.st_fullscreenPopGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.st_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.st_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
        [self.st_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self st_pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (UIPanGestureRecognizer *)st_fullscreenPopGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}
- (STFullscreenPopGestureRecognizerDelegate *)fd_popGestureRecognizerDelegate {
    STFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[STFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (void)st_popNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        STPopDisplayCount += 1;
        CGFloat popProgress = [self st_popProgress];
        UIViewController *fromeVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self st_updateNavigationBarWithFromVC:fromeVC toVC:toVC progress:popProgress];
    }
}

- (void)st_pushNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        STPushDisplayCount += 1;
        CGFloat pushProgress = [self st_pushProgress];
        UIViewController *fromeVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self st_updateNavigationBarWithFromVC:fromeVC toVC:toVC progress:pushProgress];
    }
}

#pragma mark - 解决手势返回
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    @weakify(self);
    // 转场动画
    id <UIViewControllerTransitionCoordinator> coordinator = [self.topViewController transitionCoordinator];
    if ([coordinator initiallyInteractive] == YES) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
            [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                @strongify(self);
                [self st_dealInteractionChanges:context];
            }];
        }else{
            [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                @strongify(self);
                [self st_dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVc = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVc animated:YES];
    
    return YES;
}


- (void)st_dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIColor *curColor = [[context viewControllerForKey:key] st_navigationBarBarTintColor];
        CGFloat curAlpha = [[context viewControllerForKey:key] st_navigationBarBackgroundAlpha];
        [self st_setNeedsNavigationBarUpdateForBarTintColor:curColor];
        [self st_setNeedsNavigationBarUpdateForBarBackgroundAlpha:curAlpha];
    };
    
    // after that, cancel the gesture of return
    if ([context isCancelled] == YES) {
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}

- (void)st_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    [self st_updateNavigationBarWithFromVC:fromVC toVC:toVC progress:percentComplete];
    
    [self st_updateInteractiveTransition:percentComplete];
}

@end
