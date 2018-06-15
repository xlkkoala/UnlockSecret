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

@interface USOpenSecretViewController ()<UITableViewDelegate,UITableViewDataSource,USInputViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic, strong) NSMutableArray *commentListArray; // 评论数组
@property (nonatomic, strong) NSMutableDictionary *discussDictionary; //    评论下对应的讨论
@property (nonatomic, strong) USInputView *inputView;
@property (nonatomic, strong) USSecretDetailModel *secretModel; // 秘密
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
    [self.navigationController.navigationBar setHidden:YES];
    [self.view sendSubviewToBack:self.navigationView];
    self.tableView.estimatedSectionHeaderHeight  = 1000;
    self.tableView.estimatedRowHeight = 1000;
    [self getSecretDetail];
    [self getCommentList];
}

- (void)getSecretDetail {
    USOpenSecretDetailProcess *process = [[USOpenSecretDetailProcess alloc] init];
    process.dictionary = [@{@"secretId":@"22",@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.secretModel = response;
        //创建header
        USSecretHeaderView *view = [[USSecretHeaderView alloc] init];
        [view creatMessage:response];
        self.tableView.tableHeaderView = view;
        //创建inputview
        self.inputView = [[USInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (_IPHONE_X?64:40), SCREEN_WIDTH, (_IPHONE_X?64:40))];
        self.inputView.delegate = self;
        [self.inputView creatUIByModel:response];
        [self.view addSubview:self.inputView];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)getCommentList {
    USCommentListProcess *process = [[USCommentListProcess alloc] init];
    process.dictionary = [@{@"secretId":@"22",@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.commentListArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)getReplyDetail:(NSInteger)section {
    USReplyDetailProcess *process = [[USReplyDetailProcess alloc] init];
    USCommentListModel *model = self.commentListArray[section];
    process.dictionary = [@{@"commentId":model.comment_id}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [self.discussDictionary setObject:response forKey:[NSString stringWithFormat:@"%ld",(long)section]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)userLikeCommentBySection:(NSInteger)section {
    USLikeCommentProcess *process = [[USLikeCommentProcess alloc] init];
    USCommentListModel *model = self.commentListArray[section];
    process.dictionary = [@{@"commentId":model.comment_id,@"userId":USER_ID}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        model.isPraise = @"1";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)userLikeSecret {
    USLikeSecretProcess *process = [[USLikeSecretProcess alloc] init];
    process.dictionary = [@{@"secretId":self.secretModel.secretId,@"userId":USER_ID}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [self.inputView changeLikeBtn:YES];
    } errorBlock:^(NSError *error) {
        
    }];
    
}

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
    [view.replayBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //replay
    }];
    [view.likeBtn setTitle:model.praise forState:UIControlStateNormal];
    //根据ispraise 判断点赞状态
    if ([model.isPraise integerValue] == 0) {
        [view.likeBtn setBackgroundColor:[UIColor grayColor]];
        view.userInteractionEnabled = YES;
    }else{
        [view.likeBtn setBackgroundColor:[UIColor redColor]];
        view.userInteractionEnabled = NO;
    }
    [view.likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //点赞或者取消点赞
        [self userLikeCommentBySection:section];
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
         NSMutableArray *discussArray = [self.discussDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
        if (discussArray) {
            return nil;
        }else{
            USSessionFooterView *view = [[[NSBundle mainBundle] loadNibNamed:@"USSessionFooterView" owner:nil options:nil] firstObject];
            [view.queryReplyDetailBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                //查看回复详情
                [self getReplyDetail:section];
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
        NSMutableArray *discussArray = [self.discussDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
        if (discussArray) {
            return discussArray.count;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECRET_CELL" forIndexPath:indexPath];
    NSMutableArray *array = [self.discussDictionary objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

// 返回
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 评论
- (void)textFieldShouldReturnInputView:(UITextField *)textField {
    NSLog(@"comment");
}

// 点赞
- (void)likeCurrentSecretClick:(BOOL)isLike {
    NSLog(@"like");
    [self userLikeSecret];
}

// move
- (void)commentBtnClick {
    NSLog(@"move");
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
