//
//  USFocusViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USFocusViewController.h"
#import "USFocusTableViewCell.h"
#import "USFocusListProcess.h"

@interface USFocusViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrFcous;

@end

@implementation USFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFocusListData];
}

#pragma mark - 数据请求

//获取关注列表
- (void)getFocusListData{
    
    __weak typeof(self) weakself = self;
    
    USFocusListProcess *process = [[USFocusListProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        weakself.arrFcous = [NSMutableArray arrayWithArray:response];
        [weakself.tableView reloadData];
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrFcous.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USFocusTableViewCell" forIndexPath:indexPath];
    [cell showFocusInfo:self.arrFcous[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
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
