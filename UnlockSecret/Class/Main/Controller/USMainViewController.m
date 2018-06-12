//
//  USMainViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMainViewController.h"
#import "USMainProcess.h"
#import "USMainTableViewCell.h"
#import "UIViewController+PresentViewControllerOverCurrentContext.h"
#import "USMainLookingForDifferentVC.h"
#import "USMainFocusProcess.h"


@interface USMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *arrMainList;

@end

@implementation USMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMainListData];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    imageview.image = ImageNamed(@"m_xunmi");
    self.navigationItem.titleView = imageview;

}

#pragma mark - 数据请求

//获取首页列表
- (void)getMainListData{
    
    __weak typeof(self) weakself = self;
    
    USMainProcess *process = [[USMainProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID,@"pageNumber":@"0",@"pageSize":@"10"} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        weakself.arrMainList = [NSMutableArray arrayWithArray:response];
        [weakself.tableView reloadData];
        
    } errorBlock:^(NSError *error) {
        
    }];
}

//关注 type   1 添加  2为取消关注
- (void)requestFocusType:(NSString *)type attentionId:(NSString *)attentionId{
    
    [SVProgressHUD showWithStatus:nil];
    USMainFocusProcess *process = [[USMainFocusProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID,@"type":type,@"attentionId":attentionId} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:@"已关注ß"];
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrMainList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USMainTableViewCell" forIndexPath:indexPath];
    [cell showUSMainInfo:self.arrMainList[indexPath.row]];
    
    // 解密页面
    [cell.btnSecret handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        USMainLookingForDifferentVC *differentVC = [[USMainLookingForDifferentVC alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        differentVC.mainModel = self.arrMainList[indexPath.row];
        [[UIApplication sharedApplication].keyWindow addSubview:differentVC];
    }];
    
    // 关注、取消关注
    [cell.btnFocus handleControlEvent:UIControlEventTouchUpInside withBlock:^{
       
        USMainModel *model = self.arrMainList[indexPath.row];
        [self requestFocusType:@"1" attentionId:model.uid];
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
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
