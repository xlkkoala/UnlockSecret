//
//  USOpenSecretViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/8.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USOpenSecretViewController.h"
#import "USSecretHeaderView.h"
#import "USSessionHeaderView.h"
#import "USSessionFooterView.h"
#import "USInputView.h"
#import "USOpenSecretDetailProcess.h"
#import "USCommentListProcess.h"
#import "USCommentListModel.h"
#import "USReplyDetailProcess.h"
#import "USReplyModel.h"
#import "USReplyCell.h"
#import "USLikeCommentProcess.h"
#import "USLikeSecretProcess.h"
#import "USSaveCommentSecretProcess.h"
#import "USUserReplyCommentProcess.h"
#import "USCommentsDetailViewController.h"
#import "USMainFocusProcess.h"
#import "USMainModel.h"

@interface USOpenSecretViewController ()<UITableViewDelegate,UITableViewDataSource,USInputViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic, strong) USSecretHeaderView *headerview;
@property (nonatomic, strong) NSMutableArray *commentListArray; // 评论数组
@property (nonatomic, strong) NSMutableDictionary *discussDictionary; //    评论下对应的讨论
@property (nonatomic, strong) USInputView *inputView;
@property (nonatomic, strong) USSecretDetailModel *secretModel; // 秘密
@property (nonatomic, strong) NSIndexPath *replyIndex; //点击回复按钮记录
@end

@implementation USOpenSecretViewController

- (NSMutableArray *)commentListArray {
    if (!_commentListArray) {
        _commentListArray = [NSMutableArray array];
    }
    return _commentListArray;
}

- (NSMutableDictionary *)discussDictionary {
    if (!_discussDictionary) {
        _discussDictionary = [NSMutableDictionary dictionary];
    }
    return _discussDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view sendSubviewToBack:self.navigationView];
    self.tableView.estimatedSectionHeaderHeight  = 1000;
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.estimatedSectionFooterHeight = 1000;
    self.tableView.contentInset = UIEdgeInsetsMake(_IPHONE_X?0:-5, 0, 0, 0);
    [self getSecretDetail];
    [self getCommentList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - 获取秘密详情
- (void)getSecretDetail {
    USOpenSecretDetailProcess *process = [[USOpenSecretDetailProcess alloc] init];
    process.dictionary = [@{@"secretId":self.secretId?self.secretId:@"22",@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.secretModel = response;
        //创建header
        self.headerview = [[USSecretHeaderView alloc] init];
        [self.headerview creatMessage:response];
        [self.headerview.addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            NSString *type;
            if ([self.secretModel.attention isEqualToString:@"0"]) {
                type = @"1";
            }else {
                type = @"2";
            }
            [self requestFocusType:type attentionId:self.secretModel.uid];
        }];
        self.tableView.tableHeaderView = self.headerview;
        //创建inputview
        self.inputView = [[USInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (_IPHONE_X?64:40), SCREEN_WIDTH, (_IPHONE_X?64:40))];
        self.inputView.delegate = self;
        [self.inputView creatUIByModel:response];
        [self.view addSubview:self.inputView];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 获取评论列表
- (void)getCommentList {
    [SVProgressHUD show];
    USCommentListProcess *process = [[USCommentListProcess alloc] init];
    process.dictionary = [@{@"secretId":self.secretId?self.secretId:@"22",@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.commentListArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 获取评论回复详情
- (void)getReplyDetail:(NSInteger)section {
    [SVProgressHUD show];
    USReplyDetailProcess *process = [[USReplyDetailProcess alloc] init];
    USCommentListModel *model = self.commentListArray[section];
    process.dictionary = [@{@"commentId":model.comment_id}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        // 用秘密的 id 作为 key 值 （确保唯一性）
        [self.discussDictionary setObject:response forKey:[NSString stringWithFormat:@"%@",model.comment_id]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 点赞评论
- (void)userLikeCommentBySection:(NSInteger)section {
    USLikeCommentProcess *process = [[USLikeCommentProcess alloc] init];
    USCommentListModel *model = self.commentListArray[section];
    process.dictionary = [@{@"commentId":model.comment_id,@"userId":USER_ID}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        // 同时改变本地的是否点赞和点赞数量
        model.isPraise = @"1";
        model.praise = [NSString stringWithFormat:@"%ld",[model.praise integerValue] + 1];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 点赞秘密
- (void)userLikeSecret {
    USLikeSecretProcess *process = [[USLikeSecretProcess alloc] init];
    process.dictionary = [@{@"secretId":self.secretModel.secretId,@"userId":USER_ID}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [self.inputView changeLikeBtn:YES];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 用户评论用户
- (void)userReplyUser:(NSString *)content {
    USUserReplyCommentProcess *process = [[USUserReplyCommentProcess alloc] init];
    USCommentListModel *model = self.commentListArray[self.replyIndex.section];
    process.dictionary = [@{@"content":content,@"userId":USER_ID,@"commentId":model.comment_id,@"secretId":self.secretModel.secretId,@"userToUser":model.uid}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        model.commentCount = [NSString stringWithFormat:@"%ld",[model.commentCount integerValue] + 1];
        [self getReplyDetail:self.replyIndex.section];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.replyIndex.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.inputView.textField resignFirstResponder];
        self.replyIndex = nil;
    } errorBlock:^(NSError *error) {
        [self.inputView.textField resignFirstResponder];
        self.replyIndex = nil;
    }];
}

#pragma mark - 用户评论秘密
- (void)userCommentSecret:(NSString *)content {
    USSaveCommentSecretProcess *process = [[USSaveCommentSecretProcess alloc] init];
    process.dictionary = [@{@"content":content,@"userId":USER_ID,@"secretId":self.secretModel.secretId,@"address":@""}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [self getCommentList];
        [self.inputView.textField resignFirstResponder];
    } errorBlock:^(NSError *error) {
        [self.inputView.textField resignFirstResponder];
    }];
}

//关注 type   1 添加  2为取消关注
- (void)requestFocusType:(NSString *)type attentionId:(NSString *)attentionId{
    
    [SVProgressHUD showWithStatus:nil];
    USMainFocusProcess *process = [[USMainFocusProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID,@"type":type,@"attentionId":attentionId} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        if ([type isEqualToString:@"1"]) {
            self.secretModel.attention = @"1";
            self.headerview.addBtn.titleLabel.text = @"-";
            [SVProgressHUD showSuccessWithStatus:@"已关注"];
        }else {
            self.secretModel.attention = @"0";
            self.headerview.addBtn.titleLabel.text = @"+";
            [SVProgressHUD showSuccessWithStatus:@"已取消"];
        }
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - tableView  Delegate And Datasource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     //如果热门存在 第一个显示热门评论（数量）  热门数量+1 显示全部评论（数量）
     //热门评论不存在 第一个显示全部评论（数量）
     */
    USCommentListModel *model = self.commentListArray[section];
    USSessionHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"USSessionHeaderView" owner:nil options:nil] firstObject];
    if (section == 0) {
        view.commentHeight.constant = 20;
        view.commentLabel.hidden = NO;
    }else{
        view.commentHeight.constant = 0;
        view.commentLabel.hidden = YES;
    }
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
        [self performSegueWithIdentifier:@"COMMENTS_DETAIL" sender:model];
//        self.replyIndex = [NSIndexPath indexPathForRow:0 inSection:section];
//        [self.inputView.textField becomeFirstResponder];
    }];
    [view layoutIfNeeded];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // 根据返回数据判断对应的评论底下是否有更多的探讨
    USCommentListModel *model = self.commentListArray[section];
    NSInteger count = [model.commentCount integerValue];
    if (count == 0) {
        return nil;
    }else{
         NSMutableArray *discussArray = [self.discussDictionary objectForKey:[NSString stringWithFormat:@"%@",((USCommentListModel *)self.commentListArray[section]).comment_id]];
        if (discussArray) {
            return nil;
        }else{
            USSessionFooterView *view = [[[NSBundle mainBundle] loadNibNamed:@"USSessionFooterView" owner:nil options:nil] firstObject];
            [view.queryReplyDetailBtn setTitle:[NSString stringWithFormat:@"查看全部%ld条回复 >",(long)count] forState:UIControlStateNormal];
            [view.queryReplyDetailBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                //查看回复详情
//                [self getReplyDetail:section];
                [self performSegueWithIdentifier:@"COMMENTS_DETAIL" sender:model];
            }];
            return view;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 返回评论的总数  （热门 + 全部）
    return self.commentListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //评论下探讨的数量
    USCommentListModel *model = self.commentListArray[section];
    NSInteger count = [model.commentCount integerValue];
    if (count > 0) {
        if ([self.discussDictionary.allKeys containsObject:model.comment_id]) {
            return ((NSMutableArray *)[self.discussDictionary objectForKey:model.comment_id]).count;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECRET_CELL" forIndexPath:indexPath];
    NSMutableArray *array = [self.discussDictionary objectForKey:[NSString stringWithFormat:@"%@",((USCommentListModel *)self.commentListArray[indexPath.section]).comment_id]];
    USReplyModel *model = array[indexPath.row];
    cell.replyLabel.text = [NSString stringWithFormat:@"%@:%@",model.name,model.content];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.replyIndex = nil;
    [self.view endEditing:YES];
}

#pragma mark - back
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送评论
- (void)textFieldShouldReturnInputView:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        self.replyIndex = nil;
        return;
    }
    if (self.replyIndex) {
        // 用户回复用户
        [self userReplyUser:textField.text];
    }else{
        // 用户回复秘密
        [self userCommentSecret:textField.text];
    }
}

#pragma mark - 点赞秘密按钮click
- (void)likeCurrentSecretClick:(BOOL)isLike {
    [self userLikeSecret];
}

#pragma mark - move
- (void)commentBtnClick {
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    NSLog(@"move");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    USCommentsDetailViewController *vc = segue.destinationViewController;
    vc.comments = sender;
    vc.secretId = self.secretModel.secretId;
}

@end
