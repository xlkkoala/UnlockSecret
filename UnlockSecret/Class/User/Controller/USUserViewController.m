//
//  USUserViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUserViewController.h"
#import "UIView+FrameTool.h"
#import "USUserInfoCell.h"
#import "USUserSecretCell.h"

#define HEADER_HEIGHT SCREEN_HEIGHT/2

@interface USUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIView *secretView;//session （发布，浏览，取消）
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *aboutSecretBtnArray;//session button （发布，浏览，取消）
@property (nonatomic, assign) NSInteger currentSelect;// 当前选择（发布/浏览/取消）

@end

@implementation USUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareHeaderView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _IPHONE_X?SCREEN_HEIGHT-83:SCREEN_HEIGHT-49);
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT-60, 0, 0, 0);
    self.tableView.estimatedRowHeight = 300;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)prepareHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:self.headerView];
    self.headerImageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
    self.headerImageView.backgroundColor = [UIColor cyanColor];
    self.headerImageView.contentMode = UIViewContentModeScaleToFill;
    self.headerImageView.clipsToBounds = YES;
    [_headerView addSubview:_headerImageView];
    self.headerImageView.image = [UIImage imageNamed:@"m_xunmi"];
    [self.view sendSubviewToBack:self.headerView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        USUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USER_MESSAGE_CELL" forIndexPath:indexPath];
        cell.likeNumber.text = @"1314";
        [cell changeUIByUser:OWN];
        return cell;
    }
    USUserSecretCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USER_SECRET_CELL" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.currentSelect == 0) {
            ((UIButton *)self.aboutSecretBtnArray[0]).selected = YES;
        }
        return self.secretView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 60.f;
    }else {
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UITableViewAutomaticDimension;
    }
    return 60;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    NSLog(@"%f",offset);
    if (offset <= 0) {
        self.headerView.y = 0;
        self.headerView.height = HEADER_HEIGHT - offset;
        self.headerView.width = SCREEN_WIDTH - offset;
        self.headerImageView.alpha = 1;
    }else {
//        self.headerView.height = HEADER_HEIGHT - offset;
//
//        CGFloat min = HEADER_HEIGHT - 64;
//        CGFloat progress = 1 - (offset/min);
//        self.headerImageView.alpha = progress;
//
//        self.statusBarStyle = (progress < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
//        [self.navigationController setNeedsStatusBarAppearanceUpdate];
        
    }
    self.headerImageView.height = self.headerView.height;
}

- (IBAction)aboutSecretBtnClick:(UIButton *)sender {
    self.currentSelect =  sender.tag;
    for (UIButton *btn in self.aboutSecretBtnArray) {
        if (btn.tag == self.currentSelect) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
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
