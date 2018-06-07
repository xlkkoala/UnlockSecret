//
//  USFocusTableViewCell.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USFocusTableViewCell.h"

@implementation USFocusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showFocusInfo:(USFocusListModel *)model{
    
    [self.imageViewHeader sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.photo, 150, 150)] placeholderImage:DEFAULT_IMAGE_HEADER];
    self.lblName.text = model.name;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
