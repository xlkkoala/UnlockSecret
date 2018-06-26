//
//  YNTextField.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/25.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNTextField;

@protocol YNTextFieldDelegate <NSObject>

- (void)ynTextFieldDeleteBackward:(YNTextField *)textField;
@end

@interface YNTextField : UITextField

@property (nonatomic, assign) id <YNTextFieldDelegate> yn_delegate;

@end
