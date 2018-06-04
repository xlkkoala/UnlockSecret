//
//  UIAlertView+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonClickedAction)(NSInteger buttonIndex);

@interface UIAlertView (Joker)

/**
 * 显示AlertView,处理点击事件
 */
- (void)showAlertViewWithCompleteBlock:(ButtonClickedAction) block;

@end
