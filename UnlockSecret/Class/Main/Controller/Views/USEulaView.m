//
//  USEulaView.m
//  UnlockSecret
//
//  Created by xlk on 2018/9/1.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USEulaView.h"

@implementation USEulaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( self ){
        self = [[[NSBundle mainBundle] loadNibNamed:@"USEulaView" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    
    return self;
}
- (IBAction)readBtnClick:(UIButton *)sender {
    sender.selected =! sender.selected;
}

- (IBAction)agreeClick:(UIButton *)sender {
    if (self.readBtn.selected == NO) {
        [SVProgressHUD showInfoWithStatus:@"请仔细阅读用户协议条款后并选中已阅读按钮"];
    }else {
        // 用户条款设为已读
        [USER_DEFAULT setObject:@"1" forKey:EULA];
        [self removeFromSuperview];
    }
}

@end
