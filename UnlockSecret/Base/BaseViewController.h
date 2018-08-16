//
//  BaseViewController.h
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^asyncBlock)(void);
typedef void (^getMainQueue)(void);

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIImageView *imageView;

- (void)setLeftBackBtn;

- (void)async:(asyncBlock)block;

- (void)methodsInMainQueue:(getMainQueue)block;
/**
 返回背景渐变颜色
 */
- (UIColor *)backgroundGradientColor;

- (void)alertTitle:(NSString *)title message:(NSString *)message;

@end
