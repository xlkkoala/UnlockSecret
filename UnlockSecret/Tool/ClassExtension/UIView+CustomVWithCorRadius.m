//
//  UIView+CustomVWithCorRadius.m
//  Che-byMall
//
//  Created by FYTech on 2017/3/3.
//  Copyright © 2017年 FYTech. All rights reserved.
//

#import "UIView+CustomVWithCorRadius.h"

@implementation UIView (CustomVWithCorRadius)


@dynamic cornerRadius;

- (void)setCornerRadius:(CGFloat)cornerRadius
{
//    self.cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorederColor:(UIColor *)borederColor
{
    self.layer.borderColor = [borederColor CGColor];
}

- (UIColor *)borederColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
