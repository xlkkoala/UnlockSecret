//
//  USMessageViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMessageViewController.h"
#import "USMessageTableViewCell.h"

@interface USMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation USMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USMessageTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
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
