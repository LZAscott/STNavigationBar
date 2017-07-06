//
//  STSinaHeaderView.h
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSinaHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (instancetype)sinaHeaderView;

@end
