//
//  USLoginView.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/25.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNTextField.h"

@interface USLoginView : UIView
// 登录
@property (weak, nonatomic)
IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UITextField *textFileldPhoneNo;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCenterY;
// 验证码
@property (weak, nonatomic) IBOutlet UIView *viewCode;
@property (weak, nonatomic) IBOutlet UILabel *lblSendCodePhoneNo;
@property (weak, nonatomic) IBOutlet UIButton *btnSendCode;
@property (weak, nonatomic) IBOutlet YNTextField *textFieldCode1;
@property (weak, nonatomic) IBOutlet YNTextField *textFieldCode2;
@property (weak, nonatomic) IBOutlet YNTextField *textFieldCode3;
@property (weak, nonatomic) IBOutlet YNTextField *textFieldCode4;

@end
