//
//  USReplyCell.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/14.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USReplyCell.h"

@implementation USReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showReplayByModel:(USReplyModel *)model andSecretComments:(USCommentListModel *)comments{
    NSString *str = @"";
    NSMutableAttributedString *AttributedStr;
    if ([model.name isEqualToString:model.toName] || [comments.name isEqualToString:model.toName] || !model.toName) {
        str = [NSString stringWithFormat:@"%@:%@",model.name,model.content];
        AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value: [UIColor blueColor]
         
                              range:NSMakeRange(0, model.name.length)];
    }else {
        str = [NSString stringWithFormat:@"%@回复%@:%@",model.name,model.toName,model.content];
        AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value: [UIColor blueColor]
         
                              range:NSMakeRange(0, model.name.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value: [UIColor blueColor]
         
                              range:NSMakeRange(model.name.length+2,model.toName.length)];
    }
    self.replyLabel.attributedText = AttributedStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
