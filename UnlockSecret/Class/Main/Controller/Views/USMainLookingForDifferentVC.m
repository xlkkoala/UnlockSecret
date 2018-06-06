//
//  USM_LookingForDifferentVC.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMainLookingForDifferentVC.h"

@implementation USMainLookingForDifferentVC

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( self ){
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"USM_LookingForDifferentVC" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        self.progressView.progressBgColor = ColorFromRGB(217, 217, 217);
        self.progressView.progressBarColor = ColorFromRGB(46, 182, 24);
        self.progressView.progress = 0.8;
        
    }
    
    return self;
}

#pragma mark - 按钮事件

// 点击不同
- (IBAction)clickDifferent:(id)sender {
    
    self.buttonImageSelect.selected = YES;
    
}
// 不想解
- (IBAction)clickClose:(id)sender {
    
    [self removeFromSuperview];
}
// 微信朋友圈求助
- (IBAction)clickWeChatFriends:(id)sender {
}
// 微信好友求助
- (IBAction)clickWeChat:(id)sender {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
