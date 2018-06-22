//
//  USUserInfoCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/11.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, USER_TYPE){
    OWN = 0,
    OTHER = 1
};

@interface USUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *fansNumber;
@property (weak, nonatomic) IBOutlet UILabel *focusNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foucusBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBtnHeight;

- (void)changeUIByUser:(USER_TYPE)type user:(USUser *)user;

@end
