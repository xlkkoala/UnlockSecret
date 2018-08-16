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
#import <MJRefresh.h>
#import "PuzzleView.h"
#import "USOpenSecretViewController.h"

@interface USMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrMainList;
@property (nonatomic, assign) int pageNumber;

@end

@implementation USMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getMainListData];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    imageview.image = ImageNamed(@"m_xunmi");
    self.navigationItem.titleView = imageview;
    
    // 渐变色
    self.view.backgroundColor = [self backgroundGradientColor];
    self.tableView.backgroundColor = UIColor.clearColor;
    
    // 其他页面点击关注用户后，通知首页刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusRefresh:) name:@"NOTIFICATIONFOCUSREFRESH" object:nil];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dropTopRefresh)];
    
    // 解决ios11以上的列表出现从下往上移动的问题
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 250;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    // 退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"NOTIFICATIONLOGOUT" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)logout{
    
    [self.arrMainList removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)focusRefresh:(NSNotification *)notification{
    
    NSString *attentionId = notification.object;
    
    for( int i = 0 ; i < self.arrMainList.count ; i++ ){
        
        USMainModel *model = self.arrMainList[i];
        if( [model.uid isEqualToString:attentionId] ){
            
            model.isAttention = 1;
            [self.arrMainList replaceObjectAtIndex:i withObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 数据请求
- (void)dropDownRefresh{
    
    self.pageNumber = 0;
    [self getMainListData];
}

- (void)dropTopRefresh{
    
    [self getMainListData];
}


//获取首页列表
- (void)getMainListData{
    
    __weak typeof(self) weakself = self;
    
    USMainProcess *process = [[USMainProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID?USER_ID:@"0",@"pageNumber":@(self.pageNumber),@"pageSize":@"10"} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        if( weakself.pageNumber == 0 ){
            
             weakself.arrMainList = [NSMutableArray array];
        }
        [weakself.arrMainList addObjectsFromArray:response];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        weakself.pageNumber ++;
        
    } errorBlock:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

//关注 type   1 添加  2为取消关注
- (void)requestFocusType:(NSString *)type attentionId:(NSString *)attentionId{
    
    [SVProgressHUD showWithStatus:nil];
    USMainFocusProcess *process = [[USMainFocusProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID,@"type":type,@"attentionId":attentionId} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {

        for( int i = 0 ; i < self.arrMainList.count ; i++ ){
            
            USMainModel *model = self.arrMainList[i];
            if( [model.uid isEqualToString:attentionId] ){
                
                model.isAttention = 1;
                [self.arrMainList replaceObjectAtIndex:i withObject:model];
            }
        }
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"已关注"];
 
        
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
    cell.backgroundColor = UIColor.clearColor;
    // 解密页面
    [cell.btnSecret handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        USMainModel *model = self.arrMainList[indexPath.row];
        
        if(model.isOpen == 1){
            
            //       已打开盒子 查看详情
            USOpenSecretViewController *openViewController = [RELEASE_STORYBOARD instantiateViewControllerWithIdentifier:@"OPEN_SECRET_ID"];
            openViewController.secretId = model.secretId;
            [self.navigationController pushViewController:openViewController animated:YES];
            
        }else{
            
            // 找不同
//            USMainLookingForDifferentVC *differentVC = [[USMainLookingForDifferentVC alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            differentVC.mainModel = model;
//            differentVC.selectIndex = indexPath.row;
//            differentVC.unlockedSuccessBlock = ^(NSInteger index) {
//              //解锁成功手动修改为已打开 刷新列表
//                model.isOpen = 1;
//                [self.arrMainList replaceObjectAtIndex:index withObject:model];
//                [self.tableView reloadData];
//
//            };
//            [[UIApplication sharedApplication].keyWindow addSubview:differentVC];
            
            PuzzleView *view = [[PuzzleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            view.mainModel = model;
            view.puzzleBlock = ^{
                //解锁成功手动修改为已打开 刷新列表
                model.isOpen = 1;
                [self.arrMainList replaceObjectAtIndex:indexPath.row withObject:model];
                self.arrMainList = self.arrMainList;
                [self.tableView reloadData];

            };
            [[UIApplication sharedApplication].keyWindow addSubview:view];
        }
       
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
