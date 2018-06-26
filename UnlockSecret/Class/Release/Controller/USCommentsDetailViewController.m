//
//  USCommentsDetailViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/21.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USCommentsDetailViewController.h"
#import "USReplyDetailProcess.h"
#import "USSessionHeaderView.h"
#import "USReplyModel.h"
#import "USLikeCommentProcess.h"
#import "USReplyCell.h"
#import "USUserReplyCommentProcess.h"

@interface USCommentsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *replyArray;
@property (nonatomic, strong) NSString *row;
@end

@implementation USCommentsDetailViewController

- (NSMutableArray *)replyArray {
    if (!_replyArray) {
        _replyArray = [NSMutableArray array];
    }
    return _replyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedSectionHeaderHeight  = 1000;
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [UIView new];
    [self getReplyDetail:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
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
        self.textField.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
        if (SCREEN_HEIGHT - self.tableView.contentSize.height < 251 + (_IPHONE_X?120:64)) {
            self.tableView.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
        }
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
        self.textField.transform = CGAffineTransformIdentity;
        self.tableView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

#pragma mark - 获取评论回复详情
- (void)getReplyDetail:(NSInteger)section {
    [SVProgressHUD show];
    USReplyDetailProcess *process = [[USReplyDetailProcess alloc] init];
    process.dictionary = [@{@"commentId":self.comments.comment_id}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.replyArray = response;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 点赞评论
- (void)userLikeCommentBySection:(NSInteger)section {
    USLikeCommentProcess *process = [[USLikeCommentProcess alloc] init];
    process.dictionary = [@{@"commentId":self.comments.comment_id,@"userId":USER_ID}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        // 同时改变本地的是否点赞和点赞数量
        self.comments.isPraise = @"1";
        self.comments.praise = [NSString stringWithFormat:@"%ld",[self.comments.praise integerValue] + 1];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 用户评论用户
- (void)userReplyUser:(NSString *)content {
    USUserReplyCommentProcess *process = [[USUserReplyCommentProcess alloc] init];
    USCommentListModel *model = self.comments;
    NSString *uid;
    if (self.row) {
        uid = self.row;
    }else {
        uid = model.uid;
    }
    process.dictionary = [@{@"content":content,@"userId":USER_ID,@"commentId":model.comment_id,@"secretId":self.secretId,@"userToUser":uid}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        model.commentCount = [NSString stringWithFormat:@"%ld",[model.commentCount integerValue] + 1];
        [self getReplyDetail:0];
        [self.textField resignFirstResponder];
        self.row = nil;
        self.textField.placeholder = @"";
    } errorBlock:^(NSError *error) {
        [self.textField resignFirstResponder];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     //如果热门存在 第一个显示热门评论（数量）  热门数量+1 显示全部评论（数量）
     //热门评论不存在 第一个显示全部评论（数量）
     */
    USCommentListModel *model = self.comments;
    USSessionHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"USSessionHeaderView" owner:nil options:nil] firstObject];
    view.commentHeight.constant = 0;
    view.commentLabel.hidden = YES;
    view.backgroundColor = [UIColor whiteColor];
    view.nameLabel.text = model.name;
    view.contentLabel.text = model.content;
    view.addressAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@",model.address,model.createTime];
    [view.headerImage sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.photo, 40, 40)] placeholderImage:DEFAULT_IMAGE_HEADER];
    
    [view.likeBtn setTitle:model.praise forState:UIControlStateNormal];
    //根据ispraise 判断点赞状态
    if ([model.isPraise integerValue] == 0) {
        [view.likeBtn setBackgroundColor:[UIColor grayColor]];
        view.likeBtn.userInteractionEnabled = YES;
    }else{
        [view.likeBtn setBackgroundColor:[UIColor redColor]];
        view.likeBtn.userInteractionEnabled = NO;
    }
    [view.likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //点赞或者取消点赞
        NSLog(@"like");
        [self userLikeCommentBySection:section];
    }];
    [view.replayBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"reply");
        [self.textField becomeFirstResponder];
    }];
    [view layoutIfNeeded];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.replyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECRET_CELL" forIndexPath:indexPath];
    USReplyModel *model = self.replyArray[indexPath.row];
    [cell showReplayByModel:model andSecretComments:self.comments];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    USReplyModel *model = self.replyArray[indexPath.row];
    self.textField.placeholder = [NSString stringWithFormat:@"回复:%@",model.name];
    [self.textField becomeFirstResponder];
    self.row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    self.row = nil;
    self.textField.placeholder = @"";
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.returnKeyType = UIReturnKeySend;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        // 回复
        [self userReplyUser:textField.text];
        textField.text = @"";
    }else {
        [textField resignFirstResponder];
    }
    return YES;
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
