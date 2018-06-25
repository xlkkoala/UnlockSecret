//
//  USLoginViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/29.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USLoginViewController.h"
#import "BaseTabbarController.h"
#import "JSHAREService.h"
#import <JMessage/JMessage.h>
#import "USLoginProcess.h"

@interface USLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation USLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([LoginHelper isUserLogin]) {
        BaseTabbarController *tabbarController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"BaseTabbarID"];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
        return;
    }
    [self initTextField];
    //判断是否登陆
    
}
#pragma mark initTextField
- (void)initTextField{
    self.userNameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_icon_sj"]];
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
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
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:self.userNameTF.font
                                        }];
    self.passwordTF.attributedPlaceholder = attrString1;
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

#pragma mark login
- (IBAction)loginBtnClick:(id)sender {
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    if ([self checkUserAndPas] == NO) {
        return;
    }
    [SVProgressHUD show];
    USLoginProcess *process = [USLoginProcess new];
    process.dictionary = [@{@"phone":self.userNameTF.text,@"password":self.passwordTF.text} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        USUser *user = (USUser *)response;
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"xunmi%@",user.userid] password:@"xunmi123456" handler:^(NSArray<__kindof JMSGDeviceInfo *> * _Nonnull devices, NSError * _Nonnull error) {
            if (!error) {
                [SVProgressHUD dismiss];
                UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                tabbar.selectedIndex = [USAppData instance].currentItenIndex?[USAppData instance].currentItenIndex:0;
            }else{
                [XLKTool saveDataByPath:nil path:nil];
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }
        }];
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];

    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];

    
}

#pragma mark qq
- (IBAction)QQLoginClick:(id)sender {
    [JSHAREService getSocialUserInfo:JSHAREPlatformQQ handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        NSString *alertMessage;
        NSString *title;
        if (error) {
            title = @"失败";
            alertMessage = @"无法获取到用户信息";
        }else{
            title = userInfo.name;
            alertMessage = [NSString stringWithFormat:@"昵称: %@\n 头像链接: %@\n 性别: %@\n",userInfo.name,userInfo.iconurl,userInfo.gender == 1? @"男" : @"女"];
        }
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Alert show];
        });
    }];
}

#pragma mark weixin
- (IBAction)WXLoginClick:(id)sender {
    [JSHAREService getSocialUserInfo:JSHAREPlatformWechatSession handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        NSString *alertMessage;
        NSString *title;
        if (error) {
            title = @"失败";
            alertMessage = @"无法获取到用户信息";
        }else{
            title = userInfo.name;
            alertMessage = [NSString stringWithFormat:@"昵称: %@\n 头像链接: %@\n 性别: %@\n",userInfo.name,userInfo.iconurl,userInfo.gender == 1? @"男" : @"女"];
        }
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Alert show];
        });
    }];
}

- (BOOL)checkUserAndPas{
    if (self.userNameTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return NO;
    }else if (self.passwordTF.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)backClick:(id)sender {
    UITabBarController *tabbar =  (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 0;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
