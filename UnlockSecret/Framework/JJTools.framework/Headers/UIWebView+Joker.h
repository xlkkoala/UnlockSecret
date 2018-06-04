//
//  UIWebView+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Joker)

/**
 *  移除UIWebView背景阴影
 */
- (void)removeBackgroundShadow;

/**
 *  加载网站
 *
 *  @param website Website to load
 */
- (void)loadWebsite:(NSString *)website;

@end
