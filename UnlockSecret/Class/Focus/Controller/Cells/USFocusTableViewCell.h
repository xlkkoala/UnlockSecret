//
//  USFocusTableViewCell.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USFocusListModel.h"

@interface USFocusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;


- (void)showFocusInfo:(USFocusListModel *)model;
@end
