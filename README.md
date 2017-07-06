<p align="center" >
<img src="Images/logo.png" title="STNavigationBar" float=left>
</p>

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/LZAscott/STNavigationBar) [![pod](https://img.shields.io/badge/pod-0.0.1-green.svg)](https://github.com/LZAscott/STNavigationBar) [![pod](https://img.shields.io/badge/platform-iOS8.0+-yellow.svg)](https://github.com/LZAscott/STNavigationBar) ![pod](https://img.shields.io/travis/rust-lang/rust/master.svg)

# 简介
一行代码设置状态栏样式和导航栏背景颜色、标题、按钮、透明度以及全屏pop手势支持。

# 特性

- [x] 为每个控制器定制了UINavigationBar支持(颜色、透明度、字体大小)
- [x] 全屏pop手势返回
- [x] 为单个控制器关闭pop手势支持
- [x] 自定义pop手势范围
- [x] 支持横竖屏
- [x] 支持自定义UINavigationBar

# Demo
![蚂蚁森林](https://github.com/LZAscott/STNavigationBar/blob/master/Images/蚂蚁森林.gif)
![QQ空间](https://github.com/LZAscott/STNavigationBar/blob/master/Images/QQ空间.gif)
![知乎日报](https://github.com/LZAscott/STNavigationBar/blob/master/Images/知乎日报.gif)
![新浪微博](https://github.com/LZAscott/STNavigationBar/blob/master/Images/新浪.gif)
![自定义导航栏](https://github.com/LZAscott/STNavigationBar/blob/master/Images/自定义导航栏.gif)


# 要求

iOS 8.0+ 

Xcode 8.0+ 

# 安装
* Cocoapods
    1. 在`podfile`里面添加`pod 'STNavigationBar', '~> 版本号'`
    2. `pod install` 

* 手动拖入

    下载代码并将`STNavigaionBar`文件夹拖入到项目中，导入头文件`#import "STNavigationBar.h"`即可。

# 使用说明
建议在AppDelegate里全局设置导航栏以及状态栏样式。

* 设置全局导航栏样式

```
[UIColor st_setDefaultNavigationBarBarTintColor:STMainNavBarColor];
[UIColor st_setDefaultNavigationBarTintColor:STNaviBarTintColor];
[UIColor st_setDefaultNavigationBarTitleColor:STNaviBarTitleColor];
[UIColor st_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
```

* 设置单个控制器导航栏样式

```
// 设置导航栏两边按钮颜色
[self st_setNavigationBarTintColor:[UIColor whiteColor]];
// 设置导航栏标题颜色
[self st_setNavigationBarTitleColor:[UIColor blackColor]];
// 设置状态栏样式
[self st_setStatusBarStyle:UIStatusBarStyleDefault];
// 设置导航栏透明度
[self st_setNavigationBarBackgroundAlpha:0];
// 设置导航栏背景颜色
[self st_setNavigationBarTitleColor:[UIColor whiteColor]];
```

* 开启/关闭手势返回

```
// YES:关闭手势/NO:开启手势
[self st_setInteractivePopDisabled:YES];
```

* 指定手势返回范围

```
[self st_setInteractivePopMaxAllowedInitialDistanceToLeftEdge:30.0];
```

* 解决UIScrollView和手势pop冲突

```
// 自定义一个UIScrollView，实现如下方法:
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:[STFullscreenPopGestureRecognizerDelegate class]]) {
            return YES;
        }
    }
    return NO;
}
```

# 联系

* 如果你发现了bug，请帮我提交issue。
* 如果你有好的建议，请帮我提交issue。
* 如果你想贡献代码，请提交请求。

# 许可证
STNavigationBar 是基于 MIT 许可证下发布的，详情请参见 [LICENSE](https://github.com/LZAscott/STNavigationBar/blob/master/LICENSE)。

