//
//  UISearchBarExtension.h
//  CustomView_PS
//
//  Created by pengshuai on 14-7-9.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * UISearchBar 扩展属性类
 */
@interface JJSearchBar : UISearchBar

/**
 * searchBarTextField placeholderColor 颜色
 */
@property (nonatomic,strong) UIColor *placeholderColor;
/**
 * searchBarTextField textColor 颜色
 */
@property (nonatomic,strong) UIColor *textColor;
/**
 * searchBarTextField backgroundColor 背景颜色
 */
@property (nonatomic,strong) UIColor *searchTextField_backgroundColor;
/**
 * searchBarTextField 边框颜色
 */
@property (nonatomic,strong) UIColor *searchTextField_borderColor;
/**
 * searchBarTextField 边框大小
 */
@property (nonatomic,strong) NSNumber *searchTextField_borderWidth;
/**
 * searchBarTextField 圆角大小
 */
@property (nonatomic,strong) NSNumber *searchTextField_cornerRadius;
/**
 * 移除 SearchBarBackground
 */
@property (nonatomic,assign) BOOL isRemoveSearchBarBackground;

@end
