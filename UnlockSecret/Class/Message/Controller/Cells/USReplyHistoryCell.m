//
//  USReplyHistoryCell.m
//  UnlockSecret
//
//  Created by xlk on 2018/8/15.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USReplyHistoryCell.h"
#import "USReplyHistoryModel.h"
@implementation USReplyHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeContentsByArray:(NSMutableArray *)array indexPath:(NSIndexPath *)index {
    USReplyHistoryModel *model = array[index.row];
    self.replyName.text = [NSString stringWithFormat:@"%@ 回复了你", model.name];
    self.replyContents.text = [NSString stringWithFormat:@"%@", model.mark];
}

@end
