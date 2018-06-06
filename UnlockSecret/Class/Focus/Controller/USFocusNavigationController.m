//
//  USFocusNavigationController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USFocusNavigationController.h"

static NSString *const FOCUS_ID = @"FOCUS_ID";

@interface USFocusNavigationController ()

@end

@implementation USFocusNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *vc = [FOCUS_STORYBOARD instantiateViewControllerWithIdentifier:FOCUS_ID];
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