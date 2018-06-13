//
//  BaseTabbarController.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseTabbarController.h"

@interface BaseTabbarController ()<UITabBarDelegate>

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:TABBAR_BACKGROUNDCOLOR];
    [UITabBar appearance].translucent = NO;
    self.selectedIndex = 0;
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
