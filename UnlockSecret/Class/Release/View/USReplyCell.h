//
//  USReplyCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/14.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USReplyModel.h"
#import "USCommentListModel.h"
@interface USReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

- (void)showReplayByModel:(USReplyModel *)model andSecretComments:(USCommentListModel *)comments;

@end
