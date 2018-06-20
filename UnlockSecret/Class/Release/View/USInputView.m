//
//  USInputView.m
//  CommentView
//
//  Created by FYTech on 2018/4/11.
//  Copyright © 2018年 FYTech. All rights reserved.
//

#import "USInputView.h"

@implementation USInputView
{
    USSecretDetailModel *_secretModel;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)creatUIByModel:(USSecretDetailModel *)model {
    
    _secretModel = model;
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
    _likeNumberLabel.text = model.praise_count;
    _likeNumberLabel.font = [UIFont systemFontOfSize:12];
    _likeNumberLabel.textAlignment = NSTextAlignmentLeft;
    [likeView addSubview:_likeNumberLabel];

    _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2-6, 6, 12)];
    _likeImageView.image = [UIImage imageNamed:@"youjiantou"];
    [likeView addSubview:_likeImageView];
    
    
    _likeBtn = [[UIButton alloc] initWithFrame:likeView.bounds];
    [_likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [likeView addSubview:_likeBtn];
    
    UIView *commentView = [[UIView alloc] init];
    commentView.frame = CGRectMake(self.bounds.size.width - 140, 0, 70, self.bounds.size.height);
    [self addSubview:commentView];
    
    _commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
    _commentNumberLabel.text = model.commentCount;
    _commentNumberLabel.font = [UIFont systemFontOfSize:12];
    _commentNumberLabel.textAlignment = NSTextAlignmentLeft;
    [commentView addSubview:_commentNumberLabel];
    
    _commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2-6, 6, 12)];
    _commentImageView.image = [UIImage imageNamed:@"youjiantou"];
    [commentView addSubview:_commentImageView];
    
    
    _commentBtn = [[UIButton alloc] initWithFrame:commentView.bounds];
    [_commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:_commentBtn];
    
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
        textField.text = @"";
    }else{
        [self.textField resignFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturnInputView:)]) {
        [self.delegate textFieldShouldReturnInputView:textField];
    }
    return YES;
}

- (void)likeClick {
    //判断当前的是点赞还是取消
    if ([_secretModel.praise isEqualToString:@"0"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeCurrentSecretClick:)]) {
            [self.delegate likeCurrentSecretClick:YES];
        }
    }else {
        NSLog(@"已经喜欢该秘密");
    }
}

- (void)commentClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentBtnClick)]) {
        [self.delegate commentBtnClick];
    }
}

- (void)changeLikeBtn:(BOOL)isLike {
    if (isLike == YES) {
        _secretModel.praise = @"1";
//        _likeImageView.image = [UIImage imageNamed:@""];
    }else{
        _secretModel.praise = @"0";
//        _likeImageView.image = [UIImage imageNamed:@""];
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
