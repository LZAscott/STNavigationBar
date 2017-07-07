//
//  STTabBarController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/28.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STTabBarController.h"
#import "STNavigationController.h"
#import "STCustomViewController.h"
#import "STNormalViewController.h"

@interface STTabBarController ()

@end

@implementation STTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addAllChildController];
}

- (void)addAllChildController {
    
    [self addOneChild:[STNormalViewController new] andTitle:@"普通" imgName:@"tabbar_home" selectImageName:@"tabbar_home_selected"];
    
    [self addOneChild:[STCustomViewController new] andTitle:@"自定义" imgName:@"tabbar_discover" selectImageName:@"tabbar_discover_selected"];
}

- (void)addOneChild:(UIViewController *)controller andTitle:(NSString *)title imgName:(NSString *)imgName selectImageName:(NSString *)selectImageName {
    controller.title = title;
    
    controller.tabBarItem.image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
