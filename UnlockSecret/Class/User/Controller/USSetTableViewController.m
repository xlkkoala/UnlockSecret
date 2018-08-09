//
//  USSetTableViewController.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/26.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USSetTableViewController.h"

@interface USSetTableViewController ()

@end

@implementation USSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 2;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self logout];
        });
    }
}

- (void)logout{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:nil message:@"退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabbar.selectedIndex = 0;
        [XLKTool saveDataByPath:nil path:nil];
        [SVProgressHUD showSuccessWithStatus:@"已退出登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONLOGOUT" object:nil];
        
    }];
    [alerController addAction:actionSure];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alerController addAction:actionCancel];
    
    [self presentViewController:alerController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
