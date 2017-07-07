//
//  STSinaHeaderView.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STSinaHeaderView.h"

@interface STSinaHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *advaImageView;

@end

@implementation STSinaHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.advaImageView.layer.cornerRadius = 40.0;
    self.advaImageView.layer.masksToBounds = YES;
}

+ (instancetype)sinaHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
