//
//  USMainViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMainViewController.h"
#import "USFocusListProcess.h"
#import "USMainTableViewCell.h"
#import "UIViewController+PresentViewControllerOverCurrentContext.h"
#import "USMainLookingForDifferentVC.h"

@interface USMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation USMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getFocusData];
}

//获取关注列表
- (void)getFocusData{
    USFocusListProcess *process = [[USFocusListProcess alloc] init];
    process.dictionary = [@{@"userId":@"1"} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USMainTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USMainLookingForDifferentVC *differentVC = [[USMainLookingForDifferentVC alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:differentVC];
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
