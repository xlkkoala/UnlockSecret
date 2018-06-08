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

@interface USOpenSecretViewController ()<UITableViewDelegate,UITableViewDataSource,USInputViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic, strong) USInputView *inputView;
@end

@implementation USOpenSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.view sendSubviewToBack:self.navigationView];
    USSecretHeaderView *view = [[USSecretHeaderView alloc] init];
    self.tableView.tableHeaderView = view;
    self.tableView.estimatedSectionHeaderHeight  = 1000;
    self.tableView.estimatedRowHeight = 1000;
    
    self.inputView = [[USInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (_IPHONE_X?64:40), SCREEN_WIDTH, (_IPHONE_X?64:40))];
    [self.view addSubview:self.inputView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     //如果热门存在 第一个显示热门评论（数量）  热门数量+1 显示全部评论（数量）
     //热门评论不存在 第一个显示全部评论（数量）
     */
    USSessionHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"USSessionHeaderView" owner:nil options:nil] firstObject];
    if (section == 0) {
        view.commentLabel.hidden = NO;
    }else{
        view.commentHeight.constant = 0;
        [view layoutIfNeeded];
        view.commentLabel.hidden = YES;
    }
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // 根据返回数据判断对应的评论底下是否有更多的探讨
    USSessionFooterView *view = [[[NSBundle mainBundle] loadNibNamed:@"USSessionFooterView" owner:nil options:nil] firstObject];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 返回评论的总数  （热门 + 全部）
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //评论下探讨的数量
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECRET_CELL" forIndexPath:indexPath];
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
    
}

// 点赞
- (void)likeCurrentSecretClick:(BOOL)isLike {
    
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
