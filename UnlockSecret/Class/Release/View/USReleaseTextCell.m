//
//  USReleaseTextCell.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USReleaseTextCell.h"

@implementation USReleaseTextCell

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"开始输入你心中的小秘密吧 ...";
    }else {
        self.placeholderLabel.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        if ([self.delegate respondsToSelector:@selector(textHaveTouchDone)]) {
            [self.delegate textHaveTouchDone];
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textHaveTouchDone)]) {
        [self.delegate textHaveTouchDone];
    }
    return YES;
}

@end
