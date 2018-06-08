//
//  USInputView.m
//  CommentView
//
//  Created by FYTech on 2018/4/11.
//  Copyright © 2018年 FYTech. All rights reserved.
//

#import "USInputView.h"

@implementation USInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _textField.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 12)];
    ((UIImageView *)_textField.leftView).image = [UIImage imageNamed:@"youjiantou"];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    _textField.placeholder = @"我要吐槽";
    [self addSubview:_textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [_textField becomeFirstResponder];
    
    UIView *likeView = [[UIView alloc] init];
    likeView.frame = CGRectMake(self.bounds.size.width - 70, 0, 70, self.bounds.size.height);
    [self addSubview:likeView];

    _likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
    _likeNumberLabel.text = @"1024";
    _likeNumberLabel.font = [UIFont systemFontOfSize:12];
    _likeNumberLabel.textAlignment = NSTextAlignmentLeft;
    [likeView addSubview:_likeNumberLabel];

    _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2-6, 6, 12)];
    _likeImageView.image = [UIImage imageNamed:@"youjiantou"];
    [likeView addSubview:_likeImageView];
    
    
    _likeBtn = [[UIButton alloc] initWithFrame:likeView.bounds];
    [_likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [likeView addSubview:_likeBtn];
    
}

- (void)keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
        self.tableView.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
//    _textField.placeholder = self.placeHolder?self.placeHolder:@"评论";
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.transform = CGAffineTransformIdentity;
        self.tableView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturnInputView:)]) {
            [self.delegate textFieldShouldReturnInputView:textField];
        }
        textField.text = @"";
    }else{
        [self.textField resignFirstResponder];
    }
    return YES;
}

- (void)likeClick {
    //判断当前的是点赞还是取消
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeCurrentSecretClick:)]) {
        [self.delegate likeCurrentSecretClick:YES];
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
