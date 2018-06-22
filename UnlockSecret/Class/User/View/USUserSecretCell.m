//
//  USUserSecretCell.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/12.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUserSecretCell.h"

@implementation USUserSecretCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)changeUIByModel:(USSecretListModel *)model {
    if (!model.photo || !model.name || !model.uid) {
        USUser *user = [LoginHelper currentUser];
        model.photo = user.photo;
        model.name = user.name;
        model.uid = [user.userid stringValue];
    }
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",IMAGEURL(model.photo, 40, 40)]] placeholderImage:DEFAULT_IMAGE_HEADER];
    self.titleLabel.text = model.title;
    self.nameLabel.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
