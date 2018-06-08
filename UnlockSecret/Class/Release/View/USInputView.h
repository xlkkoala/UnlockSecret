//
//  USInputView.h
//  CommentView
//
//  Created by FYTech on 2018/4/11.
//  Copyright © 2018年 FYTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol USInputViewDelegate <NSObject>

@optional

- (void)textFieldShouldReturnInputView:(UITextField *)textField;

- (void)likeCurrentSecretClick:(BOOL)isLike;

@end


@interface USInputView : UIView<UITextFieldDelegate>

@property (nonatomic, assign) id<USInputViewDelegate>delegate;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIButton *likeBtn;
- (instancetype)initWithFrame:(CGRect)frame;

@end
