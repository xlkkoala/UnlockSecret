//
//  USMessageListController.m
//  UnlockSecret
//
//  Created by xlk on 2018/8/9.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMessageListController.h"
#import "USFansCell.h"
#import "USGetFansListProcess.h"
#import "USFocusDetailViewController.h"
#import "USFansModel.h"

@interface USMessageListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation USMessageListController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self backgroundGradientColor];
    self.tableView.tableFooterView = [UIView new];
    [self requestFansList];
}

- (void)requestFansList {
    USGetFansListProcess *process = [[USGetFansListProcess alloc] init];
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
    USFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USFANSCELL" forIndexPath:indexPath];
    [cell makeContentsByArray:_dataArray indexPath:indexPath];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    USFocusDetailViewController *vc = [FOCUS_STORYBOARD instantiateViewControllerWithIdentifier:@"FOCUS_DETAIL_ID"];
    vc.userId = ((USFansModel *)self.dataArray[indexPath.row]).uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
