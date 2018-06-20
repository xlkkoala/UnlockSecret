//
//  USMainTableViewCell.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMainTableViewCell.h"

@implementation USMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showUSMainInfo:(USMainModel *)model{
    
    [self.imageViewHeader sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.photo, 150, 150)] placeholderImage:DEFAULT_IMAGE_HEADER];
    
    if( model.isOpen ){
        
        [self.imageViewSystem sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.open_pic, 150, 150)] placeholderImage:ImageNamed(@"m_envelope")];
    }else{
        
        [self.imageViewSystem sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.no_pic, 150, 150)] placeholderImage:ImageNamed(@"m_envelope")];
    }
    
    self.lblContent.text = model.title;
    self.lblOpenCount.text = StringFormat(@"%@人拆开",model.open_count);
    self.btnFocus.hidden = model.isAttention;
    if( [StringValue(USER_ID) isEqualToString:StringValue(model.uid)] ){
        
        self.btnFocus.hidden = YES;
    }
    [self.btnPraiseCount setNormalTitle:StringFormat(@" %@",model.praise_count)];
    [self.btnCommentCount setNormalTitle:StringFormat(@" %@",model.comment_count)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
