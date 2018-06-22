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

- (void)changeUIByUser:(USER_TYPE)type user:(USUser *)user{
    if (!type || type == OWN) {
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
    self.likeNumber.text = [user.praiseCount stringValue];
    self.fansNumber.text = [user.fans stringValue];
    self.focusNumber.text = [user.attentionCount stringValue];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(user.photo, 80, 80)] placeholderImage:DEFAULT_IMAGE_HEADER];
    self.nameLabel.text = user.name;
    self.signatureLabel.text = user.ddescription.length>0?[NSString stringWithFormat:@"签名:%@",user.ddescription]:@"签名:暂时没有任何心情哦～";
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
