//
//  BaseTabbarController.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseTabbarController.h"
#import "USLoginViewController.h"
@interface BaseTabbarController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBar appearance] setBarTintColor:ColorFromRGB(57, 66, 111)];
    [UITabBar appearance].translucent = YES;
    self.selectedIndex = 0;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController != self.viewControllers[0] ) {
        if (![LoginHelper isUserLogin]) {
            //登录
            USLoginViewController *vc = [LOGIN_STORYBOARD instantiateViewControllerWithIdentifier:@"LOGIN_ID"];
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
        return NO;
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (![item isEqual:[tabBar.items objectAtIndex:2]]) {
        NSInteger currentIndex;
        if ([item.title isEqualToString:@"首页"]) {
            currentIndex = 0;
        }else if ([item.title isEqualToString:@"关注"]) {
            currentIndex = 1;
        }else if ([item.title isEqualToString:@"消息"]) {
            currentIndex = 3;
        }else {
            currentIndex = 4;
        }
        [USAppData instance].currentItenIndex = currentIndex;
    }
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
