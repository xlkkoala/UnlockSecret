//
//  USUserEditTableViewController.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/21.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseTableViewController.h"

/**
 编辑个人资料
 */
@interface USUserEditTableViewController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNickname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthday;
@property (weak, nonatomic) IBOutlet UITextView *textViewSignature;


@end
