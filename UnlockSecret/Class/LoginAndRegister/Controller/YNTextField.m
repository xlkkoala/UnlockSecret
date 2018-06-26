//
//  YNTextField.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/25.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "YNTextField.h"

@implementation YNTextField

- (void)deleteBackward {
    
//    ！！！这里要调用super方法，要不然删不了东西
    
    [super deleteBackward];
    
    if ([self.yn_delegate respondsToSelector:@selector(ynTextFieldDeleteBackward:)]) {
        
        [self.yn_delegate ynTextFieldDeleteBackward:self];
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
