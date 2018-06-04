//
//  UIView+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Joker)
/**
 *  初始化有背景色的UIView
 *
 *  @param frame           UIView's frame
 *  @param backgroundColor UIView's background color
 */
+ (UIView *)initWithFrame:(CGRect)frame
          backgroundColor:(UIColor *)backgroundColor;

#pragma mark -
#pragma mark - 设置UIView相关属性
/**
 *  设置UIView 圆角,边框大小,边框颜色
 *
 *  @param color  Border's color
 *  @param radius Border's radius
 *  @param width  Border's width
 */
- (void)setBorderColor:(UIColor *)color
           borderWidth:(CGFloat)width
          cornerRadius:(CGFloat)radius;

/**
 *  移除UIView边框及圆角
 */
- (void)removeBorders;

/**
 *  设置UIView 阴影效果
 *
 *  @param offset  Shadow's offset
 *  @param opacity Shadow's opacity
 *  @param radius  Shadow's radius
 */
- (void)setShadowWithOffset:(CGSize)offset
                    opacity:(CGFloat)opacity
                     radius:(CGFloat)radius;

/**
 *  设置UIView 阴影效果(颜色)
 *
 *  @param offset  Shadow's offset
 *  @param opacity Shadow's opacity
 *  @param radius  Shadow's radius
 */
- (void)setShadowWithOffset:(CGSize)offset
                    opacity:(CGFloat)opacity
                     radius:(CGFloat)radius
                      color:(UIColor*)color;

/**
 *  设置UIView 阴影效果(圆角)
 *
 *  @param cornerRadius Corner radius value
 *  @param offset       Shadow's offset
 *  @param opacity      Shadow's opacity
 *  @param radius       Shadow's radius
 */
- (void)setShadowWithOffset:(CGSize)offset
                    opacity:(CGFloat)opacity
                     radius:(CGFloat)radius
               cornerRadius:(CGFloat)cornerRadius;

/**
 *  设置UIView 阴影效果(圆角,颜色)
 *
 *  @param cornerRadius Corner radius value
 *  @param offset       Shadow's offset
 *  @param opacity      Shadow's opacity
 *  @param radius       Shadow's radius
 *  @param color        Shadow's color
 */
- (void)setShadowWithOffset:(CGSize)offset
                    opacity:(CGFloat)opacity
                     radius:(CGFloat)radius
               cornerRadius:(CGFloat)cornerRadius
                      color:(UIColor*)color;

/**
 *  移除UIView 阴影效果
 */
- (void)removeShadow;

/**
 *  设置UIView 圆角
 *
 *  @param radius Radius value
 */
- (void)setCornerRadius:(CGFloat)radius;



@end







