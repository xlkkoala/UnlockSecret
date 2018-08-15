//
//  USCommentsListController.m
//  UnlockSecret
//
//  Created by xlk on 2018/8/9.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USCommentsListController.h"
#import "USReplyListProcess.h"
#import "USReplyHistoryCell.h"

@interface USCommentsListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation USCommentsListController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = [self backgroundGradientColor];
    [self requestFansList];
}

- (void)requestFansList {
    USReplyListProcess *process = [[USReplyListProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.dataArray = (NSMutableArray *)response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USReplyHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_HISTORY_CELL" forIndexPath:indexPath];
    [cell makeContentsByArray:self.dataArray indexPath:indexPath];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
