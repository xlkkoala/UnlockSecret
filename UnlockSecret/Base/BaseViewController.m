//
//  BaseViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+ColorAtPixel.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count > 1) {
        [self setLeftBackBtn];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark   设置导航左侧按钮
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

- (void)async:(asyncBlock)block{
    dispatch_async(dispatch_queue_create("UnlockSecret", DISPATCH_QUEUE_CONCURRENT), ^{
        block();
    });
}

- (void)methodsInMainQueue:(getMainQueue)block{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
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

/// 用户提示
- (void)alertTitle:(NSString *)title message:(NSString *)message {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
