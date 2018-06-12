//
//  USUserInfoCell.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/11.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUserInfoCell.h"
#import "UIView+FrameTool.h"
@implementation USUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)changeUIByUser:(USER_TYPE)type{
    if (!type) {
        self.focusBtn.hidden = YES;
        self.messageBtn.hidden = YES;
        self.foucusBtnHeight.constant = 0;
        self.messageBtnHeight.constant = 0;
    }else{
        self.focusBtn.hidden = NO;
        self.messageBtn.hidden = NO;
        self.foucusBtnHeight.constant = 20;
        self.messageBtnHeight.constant = 20;
    }
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
