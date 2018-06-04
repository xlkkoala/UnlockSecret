//
//  UIButton+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ActionBlock)();

@interface UIButton (Joker)

/*!
 * Event事件处理
 * @param controlEvent 事件类型
 * @param action action block
 */
- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

#pragma mark -
#pragma mark - UIButton title
-(void)setNormalTitle:(NSString*)title;
-(void)sethighlightedTitle:(NSString*)title;
-(void)setSelectedTitle:(NSString*)title;
-(void)setDisabledTitle:(NSString*)title;

#pragma mark -
#pragma mark - UIButton title color
-(void)setNormalTitleColor:(UIColor*)color;
-(void)sethighlightedTitleColor:(UIColor*)color;
-(void)setSelectedTitleColor:(UIColor*)color;
-(void)setDisabledTitleColor:(UIColor*)color;

#pragma mark -
#pragma mark - UIButton background iamge
-(void)setNormalBackgroundImage:(UIImage*)image;
-(void)sethighlightedBackgroundImage:(UIImage*)image;
-(void)setSelectedBackgroundImage:(UIImage*)image;
-(void)setDisabledBackgroundImage:(UIImage*)image;

#pragma mark -
#pragma mark - UIButton image
- (void)setNormalImage:(UIImage *)image;
- (void)setHightlightedImage:(UIImage *)image;
- (void)setSelectedImage:(UIImage *)image;
- (void)setDisabledImage:(UIImage *)image;



@end
