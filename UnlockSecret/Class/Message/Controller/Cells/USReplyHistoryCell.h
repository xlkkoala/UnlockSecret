//
//  USReplyHistoryCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/8/15.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USReplyHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *replyName;
@property (weak, nonatomic) IBOutlet UILabel *replyContents;

- (void)makeContentsByArray:(NSMutableArray *)array indexPath:(NSIndexPath *)index;

@end
