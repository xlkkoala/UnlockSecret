//
//  UIView+Anim.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Anim)
/**
 *  震动效果
 */
- (void)shakeAnim;

/**
 *  脉冲效果
 *
 *  @param seconds Seconds of animation
 */
- (void)pulseAnimWithDuration:(CGFloat)seconds;

@end
