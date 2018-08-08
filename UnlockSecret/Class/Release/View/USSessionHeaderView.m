//
//  USSessionHeaderView.m
//  HeaderView
//
//  Created by xlk on 2018/6/7.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USSessionHeaderView.h"

@implementation USSessionHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.likeBtn.imageView.frame.size.height + 30 ,-self.likeBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [self.likeBtn setImageEdgeInsets:UIEdgeInsetsMake(-15.0, 0.0,0.0, -self.likeBtn.titleLabel.bounds.size.width)];
}


@end
