//
//  USReleaseNavigationController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USReleaseNavigationController.h"

static NSString *const RELEASE_ID = @"RELEASE_ID";

@interface USReleaseNavigationController ()

@end

@implementation USReleaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:NAV_FONT,NSForegroundColorAttributeName:NAV_COLOR}];
    
    [self.navigationBar setBarTintColor:NAV_BACKGROUNDCOLOR];
    UIViewController *vc = [RELEASE_STORYBOARD instantiateViewControllerWithIdentifier:RELEASE_ID];
    self.viewControllers = @[vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
