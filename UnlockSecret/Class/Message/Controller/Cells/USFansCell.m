//
//  USFansCell.m
//  UnlockSecret
//
//  Created by xlk on 2018/8/15.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USFansCell.h"
#import "USFansModel.h"
@implementation USFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeContentsByArray:(NSMutableArray *)array indexPath:(NSIndexPath *)index {
    USFansModel *model = array[index.row];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.photo, 60, 60)] placeholderImage:DEFUALT_HEADER_IMAGE];
    self.focusName.text = [NSString stringWithFormat:@"%@ 关注了你",model.name];
    self.focusTime.text = model.birthday;
}

@end
