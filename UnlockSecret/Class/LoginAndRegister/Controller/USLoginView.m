//
//  USLoginView.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/25.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USLoginView.h"
#import <JMessage/JMessage.h>
#import "USCheckCodeProcess.h"
#import "USRegisterProcess.h"
#import "USLoginProcess.h"
#import <SMS_SDK/SMSSDK.h>

#define colorLine ColorFromRGB(86, 89, 125)
#define colorGray ColorFromRGB(210, 210, 210)

@interface USLoginView()<YNTextFieldDelegate>{
    
    NSTimer *timer;
}

@property (nonatomic, assign) NSInteger timeCount;
// success 1没有注册 0 已注册
@property (nonatomic, assign) NSInteger success;

@end

@implementation USLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( self ){
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        self = [[[NSBundle mainBundle] loadNibNamed:@"USLoginView" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        // 注册键盘输入
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoText:) name:UITextFieldTextDidChangeNotification object:nil];
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [self.textFileldPhoneNo becomeFirstResponder];
        self.textFieldCode1.tintColor = colorLine;
        self.textFieldCode1.yn_delegate = self;
        self.textFieldCode2.tintColor = colorLine;
        self.textFieldCode2.yn_delegate = self;
        self.textFieldCode3.tintColor = colorLine;
        self.textFieldCode3.yn_delegate = self;
        self.textFieldCode4.tintColor = colorLine;
        self.textFieldCode4.yn_delegate = self;
        
        self.timeCount = 60;
    }
    
    return self;
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat remainingCenterY = (SCREEN_HEIGHT - height)/2.0;
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.layoutCenterY.constant = -(SCREEN_HEIGHT/2.0 - remainingCenterY);
        [self layoutIfNeeded];
    }];
    
}
// 监听输入框
- (void)infoText:(NSNotification *)notification{
    
    UITextField *textField = (UITextField *)notification.object;
    if([self.textFileldPhoneNo isFirstResponder]){
        
        if( self.textFileldPhoneNo.text.length>=11 ){
            
            self.textFileldPhoneNo.text = [self.textFileldPhoneNo.text substringToIndex:11];
            
            self.btnNext.backgroundColor = colorLine;
            self.btnNext.userInteractionEnabled = YES;
            
        }else{
            
            self.btnNext.backgroundColor = colorGray;
            self.btnNext.userInteractionEnabled = NO;
        }
    }else if( textField.tag > 100 && textField.text.length > 0 ){
        
        [self becomeTextField:textField];
    }
}
// 监听删除
- (void)ynTextFieldDeleteBackward:(YNTextField *)textField{
    
    if( textField.tag > 100 ){
        
        [self becomeTextField:textField];
    }
}

- (void)becomeTextField:(UITextField *)textField{
    
    NSInteger tag = textField.tag;
    if( textField.text.length == 0 ){
        
        UITextField *textFieldDelete = [self viewWithTag:tag];
        textFieldDelete.layer.borderColor = colorGray.CGColor;
        
        if( tag != 101 ){
            
            textFieldDelete = [self viewWithTag:tag-1];
        }
        
        [textFieldDelete becomeFirstResponder];
        textFieldDelete.layer.borderColor = colorLine.CGColor;
        
    }else{
        
        if( textField.text.length > 1 ){
            
            textField.text = [textField.text substringFromIndex:1];
            
        }
        if( tag != 104 ){
            
            UITextField *textFieldInput = [self viewWithTag:tag+1];
            [textFieldInput becomeFirstResponder];
            textFieldInput.layer.borderColor = colorLine.CGColor;
            
        }else{
            
            // 输入完成判断是否正确
            NSString *code = StringFormat(@"%@%@%@%@",self.textFieldCode1.text,self.textFieldCode2.text,self.textFieldCode3.text,self.textFieldCode4.text);
            
            NSLog(@"验证码：%@",code);
           
            // 输入验证码完成判断是否正确
            [self requestVerificationCode:code];
        }
    }
}

#pragma mark - 按钮事件

- (IBAction)clickNext:(id)sender {
    
    [self requestDecideRegister];
    
}
- (IBAction)clickBack:(id)sender {
    
    [self.textFileldPhoneNo becomeFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.viewCode.alpha = 0;
        self.viewLogin.alpha = 1;
        [self layoutIfNeeded];
        
    }];
}

// 获取验证码
- (IBAction)clickSendCode:(id)sender {

    [self getVerCodeIsNext:NO];
}

- (IBAction)clickClose:(id)sender {

    [self endEditing:YES];
    [self removeFromSuperview];

}

#pragma mark - 数据请求
// 判断手机号是否注册过
- (void)requestDecideRegister{
    
    __weak typeof(self) weakself = self;
    weakself.viewCode.hidden = NO;
    weakself.viewLogin.hidden = NO;
    weakself.viewCode.alpha = 0;
    weakself.viewLogin.alpha = 1;
    //注册账号 再 注册IM
    USCheckCodeProcess *process = [[USCheckCodeProcess alloc] init];
    process.dictionary = [@{@"phone":self.textFileldPhoneNo.text} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        // success 1没有注册 0 已注册
        weakself.success = [response integerValue];
        [weakself getVerCodeIsNext:YES];
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
    }];
}
// 获取验证码
- (void)getVerCodeIsNext:(BOOL)isNext{
    
    __weak typeof(self) weakself = self;
    [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    // request
    if ([XLKTool checkTelNumber:self.textFileldPhoneNo.text] == NO) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.textFileldPhoneNo.text zone:@"86" template:@"" result:^(NSError *error) {
        if (!error) {
            NSLog(@"请求短信验证成功");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            });
            if( isNext ){
                // 下一步
                weakself.lblSendCodePhoneNo.text = StringFormat(@"发送验证码至%@",weakself.textFileldPhoneNo.text);
                [weakself becomeTextField:weakself.textFieldCode1];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    weakself.viewLogin.alpha = 0;
                    weakself.viewCode.alpha = 1;
                    [weakself layoutIfNeeded];
                    
                }];
            }
           
            [weakself setUpTimer];
            
        }else{
            NSLog(@"请求短信验证失败");
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }];
}
// 验证验证码是否正确
- (void)requestVerificationCode:(NSString *)code{
    
    [SVProgressHUD showWithStatus:nil];
    [SMSSDK commitVerificationCode:code phoneNumber:self.textFileldPhoneNo.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
           
            if( self.success == 1 ){
                
                // 注册
                [self requestRegisterUser];
                
            }else{
                
                // 登录
                [self requestLogin];
            }
            
        }else{
            
            for( int i = 1 ; i<= 4; i++ ){
                
                UITextField *textFieldTemp = [self viewWithTag:100 + i];
                textFieldTemp.layer.borderColor = colorGray.CGColor;
                textFieldTemp.text = @"";
            }
            
            [self.textFieldCode1 becomeFirstResponder];
            self.textFieldCode1.layer.borderColor = colorLine.CGColor;
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }
    }];
}

// 注册用户
- (void)requestRegisterUser{
    
    [SVProgressHUD show];
    //注册账号 再 注册IM
    USRegisterProcess *process = [[USRegisterProcess alloc] init];
    process.dictionary = [@{@"phone":self.textFileldPhoneNo.text,@"password":@"xunmi123456"} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        [self registerJMessage:(USUser *)response];
        
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

// 注册IM
- (void)registerJMessage:(USUser *)user{
    JMSGUserInfo *info = [[JMSGUserInfo alloc]init];
    [JMSGUser registerWithUsername:[NSString stringWithFormat:@"xunmi%@",user.userid] password:@"xunmi123456" userInfo:info completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //注册成功
//            [SVProgressHUD showSuccessWithStatus:@"注册成功，正在登录～"];
            [JMSGUser loginWithUsername:[NSString stringWithFormat:@"xunmi%@",user.userid] password:@"xunmi123456" handler:^(NSArray<__kindof JMSGDeviceInfo *> * _Nonnull devices, NSError * _Nonnull error) {
                if (!error) {
                    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    tabbar.selectedIndex = [USAppData instance].currentItenIndex?[USAppData instance].currentItenIndex:0;
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [self removeFromSuperview];
                    
                }else{
                    [XLKTool saveDataByPath:nil path:nil];
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }
            }];
        } else {
            //注册失败
            [SVProgressHUD showSuccessWithStatus:@"登录失败"];
        }
    }];
}
// 登录账号
- (void)requestLogin{
    
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    
    [SVProgressHUD show];
    USLoginProcess *process = [USLoginProcess new];
    process.dictionary = [@{@"phone":self.textFileldPhoneNo.text} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        USUser *user = (USUser *)response;
        
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"xunmi%@",user.userid] password:@"xunmi123456" handler:^(NSArray<__kindof JMSGDeviceInfo *> * _Nonnull devices, NSError * _Nonnull error) {
            if (!error) {
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [self removeFromSuperview];
                
                UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                tabbar.selectedIndex = [USAppData instance].currentItenIndex?[USAppData instance].currentItenIndex:0;
            }else{
                [XLKTool saveDataByPath:nil path:nil];
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }
        }];
        
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

#pragma mark - 倒计时
- (void)setUpTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] run];
}

- (void)updateTime{
   
    if (self.timeCount <= 0) {
        self.timeCount = 60;
        self.btnSendCode.enabled = YES;
        [self.btnSendCode setTitle:@"重新发送" forState:UIControlStateNormal];
        self.btnSendCode.layer.borderColor = colorLine.CGColor;
        [self.btnSendCode setNormalTitleColor:colorLine];
        [self->timer invalidate];
        self->timer = nil;
        
    }else{
        
        self.btnSendCode.layer.borderColor = colorGray.CGColor;
        [self.btnSendCode setNormalTitleColor:colorGray];
        self.timeCount --;
        self.btnSendCode.enabled = NO;
        [self.btnSendCode setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.timeCount] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
