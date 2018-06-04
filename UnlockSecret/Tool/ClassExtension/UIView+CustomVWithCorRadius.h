//
//  UIView+CustomVWithCorRadius.h
//  Che-byMall
//
//  Created by FYTech on 2017/3/3.
//  Copyright © 2017年 FYTech. All rights reserved.
//

#import <UIKit/UIKit.h>


//IB_DESIGNABLE

@interface UIView (CustomVWithCorRadius)


@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borederColor;

@end
