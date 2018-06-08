//
//  USMainTableViewCell.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USMainModel.h"

@interface USMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UIButton *btnFocus;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSystem;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenCount;
@property (weak, nonatomic) IBOutlet UIButton *btnPraiseCount;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentCount;
@property (weak, nonatomic) IBOutlet UIButton *btnSecret;

- (void)showUSMainInfo:(USMainModel *)model;

@end
