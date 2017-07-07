//
//  STSinaSubTableViewController.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const kSTSinaSubScrollViewDidScrollNotification;
FOUNDATION_EXPORT NSString * const kSTSinaSubTableViewControllerScrollViewKey;

@interface STSinaSubTableViewController : UITableViewController

@property (nonatomic, strong) UIScrollView *scrollView;


@end
