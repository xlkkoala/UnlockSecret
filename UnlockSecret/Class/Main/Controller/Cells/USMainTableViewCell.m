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
    
    self.lblContent.text = model.title;
    self.lblOpenCount.text = StringFormat(@"%@人拆开",model.open_count);
    [self.btnPraiseCount setNormalTitle:StringFormat(@"%@",model.praise_count)];
    [self.btnCommentCount setNormalTitle:StringFormat(@"%@",model.comment_count)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
