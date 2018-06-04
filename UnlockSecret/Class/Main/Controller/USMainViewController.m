//
//  USMainViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMainViewController.h"
#import "USFocusListProcess.h"
@interface USMainViewController ()

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
