//
//  BaseTableViewController.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/27.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIImage+ColorAtPixel.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self setLeftBackBtn];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:NAV_FONT,NSForegroundColorAttributeName:NAV_COLOR}];
    
    [self.navigationController.navigationBar setBarTintColor:NAV_BACKGROUNDCOLOR];
}

- (void)setLeftBackBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"p_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 41, 41);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 返回背景渐变颜色
 */
- (UIColor *)backgroundGradientColor{
    
    // 渐变色
    UIColor *topleftColor = ColorFromRGB(43, 50, 92);
    UIColor *bottomrightColor = ColorFromRGB(62, 37, 99);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    return [UIColor colorWithPatternImage:bgImg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 0;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
