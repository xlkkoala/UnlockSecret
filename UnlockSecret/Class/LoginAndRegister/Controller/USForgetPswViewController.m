//
//  USForgetPswViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/12.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USForgetPswViewController.h"
#import "USForgetPswProcess.h"
#import <SMS_SDK/SMSSDK.h>

@interface USForgetPswViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (nonatomic, assign) NSInteger timeCount;
@end

@implementation USForgetPswViewController
{
    NSTimer *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 60;
    [self initTextField];
}

#pragma mark initTextField
- (void)initTextField{
    self.userNameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_icon_sj"]];
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" 请输入手机号码" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:self.userNameTF.font
                                        }];
    self.userNameTF.attributedPlaceholder = attrString;
    
    self.passwordTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_icon_mm"]];
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"dl_icon_yj_guanbi"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    self.passwordTF.rightView = button;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@" 请输入新密码" attributes:
                                       @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                         NSFontAttributeName:self.passwordTF.font
                                         }];
    self.passwordTF.attributedPlaceholder = attrString1;
    
    self.codeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zc_icon_yzm"]];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@" 请输入验证码" attributes:
                                       @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                         NSFontAttributeName:self.codeTF.font
                                         }];
    self.codeTF.attributedPlaceholder = attrString2;
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.userNameTF) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return YES;
}

- (void)showPassword:(UIButton *)button{
    button.selected =! button.selected;
    if (button.selected == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"dl_icon_yj_dakai"] forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = NO;
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"dl_icon_yj_guanbi"] forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = YES;
    }
}

- (IBAction)sendCodeClick:(UIButton *)sender {
    // request
    if ([XLKTool checkTelNumber:self.userNameTF.text] == NO) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.userNameTF.text zone:@"86" template:@"" result:^(NSError *error) {
        if (!error) {
            NSLog(@"请求短信验证成功");
        }else{
            NSLog(@"请求短信验证失败");
        }
    }];
    [self setUpTimer];
}

- (void)setUpTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)updateTime{
    [self methodsInMainQueue:^{
        if (self.timeCount == 0) {
            self.timeCount = 60;
            self.sendCodeBtn.enabled = YES;
            [self.sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [self->timer invalidate];
            self->timer = nil;
        }else{
            self.timeCount --;
            self.sendCodeBtn.enabled = NO;
            [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.timeCount] forState:UIControlStateNormal];
        }
    }];
}


- (IBAction)sureClick:(id)sender {
    if (self.userNameTF.text.length == 0 || self.passwordTF.text.length == 0 || self.codeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请补全信息！"];
        return;
    }
    [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:self.userNameTF.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            USForgetPswProcess *process = [[USForgetPswProcess alloc] init];
            process.dictionary = [@{@"phone":self.userNameTF.text,@"password":self.passwordTF.text} mutableCopy];
            [process getMessageHandleWithSuccessBlock:^(id response) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } errorBlock:^(NSError *error) {
                
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:error.description];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
