//
//  STSinaSubTableViewController.m
//  STNavigationBar
//
//  Created by Scott_Mr on 2017/7/1.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "STSinaSubTableViewController.h"
#import "STNavigationBar.h"
#import "AppDelegate.h"

NSString * const kSTSinaSubScrollViewDidScrollNotification = @"kSTSinaSubScrollViewDidScrollNotification";
NSString * const kSTSinaSubTableViewControllerScrollViewKey = @"kSTSinaSubTableViewControllerScrollViewKey";

@interface STSinaSubTableViewController ()

@end

@implementation STSinaSubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self st_setNavigationBarBackgroundAlpha:0];
    [self st_setNavigationBarTitleColor:[UIColor clearColor]];
    
    self.tableView.rowHeight = 200;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView == nil) {
        self.scrollView = scrollView;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSTSinaSubScrollViewDidScrollNotification object:nil userInfo:@{kSTSinaSubTableViewControllerScrollViewKey : scrollView}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cellcontentID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%ld", self.title, indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
