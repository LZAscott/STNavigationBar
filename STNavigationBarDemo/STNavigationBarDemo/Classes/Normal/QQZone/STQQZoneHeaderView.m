//
//  STQQZoneHeaderView.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/6/30.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STQQZoneHeaderView.h"

@interface STQQZoneHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *advaImgView;


@end


@implementation STQQZoneHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.advaImgView.layer.cornerRadius = 32.0;
    self.advaImgView.layer.masksToBounds = YES;
}

+ (instancetype)zoneHeaderView {
    STQQZoneHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    return headerView;
}

@end
