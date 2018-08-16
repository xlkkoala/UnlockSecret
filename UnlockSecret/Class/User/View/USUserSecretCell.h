//
//  USUserSecretCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/12.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USSecretListModel.h"
@interface USUserSecretCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)changeUIByModel:(USSecretListModel *)model;
- (void)changeUIByOtherModel:(USSecretListModel *)model user:(USUser *)user;
@end
