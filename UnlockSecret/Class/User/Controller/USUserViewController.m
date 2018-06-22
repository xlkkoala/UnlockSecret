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
#import "USBrowseSecretProcess.h"
#import "USReleaseListProcess.h"
#import "USOpenSecretListProcess.h"
#import "USSecretListModel.h"

#define HEADER_HEIGHT SCREEN_HEIGHT/2

@interface USUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIView *secretView;//session （发布，浏览，取消）
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *aboutSecretBtnArray;//session button （发布，浏览，取消）
@property (nonatomic, assign) NSInteger currentSelect;// 当前选择（发布/浏览/取消）

@property (nonatomic, strong) NSMutableArray *releaseArray;
@property (nonatomic, strong) NSMutableArray *openArray;
@property (nonatomic, strong) NSMutableArray *likeArray;

@end

@implementation USUserViewController

- (USUser *)user {
    if (!_user) {
        _user = [LoginHelper currentUser];
    }
    return _user;
}

- (NSMutableArray *)releaseArray {
    if (!_releaseArray) {
        _releaseArray = [NSMutableArray array];
    }
    return _releaseArray;
}

- (NSMutableArray *)openArray {
    if (!_openArray) {
        _openArray = [NSMutableArray array];
    }
    return _openArray;
}

- (NSMutableArray *)likeArray {
    if (!_likeArray) {
        _likeArray = [NSMutableArray array];
    }
    return _likeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareHeaderView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _IPHONE_X?SCREEN_HEIGHT-83:SCREEN_HEIGHT-49);
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT-60, 0, 0, 0);
    self.tableView.estimatedRowHeight = 300;
}

- (void)releaseSecretList {
    USReleaseListProcess *process = [[USReleaseListProcess alloc] init];
    process.dictionary = [@{@"userId":[self.user.userid stringValue]}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.releaseArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)openSecretList {
    USOpenSecretListProcess *process = [[USOpenSecretListProcess alloc] init];
    process.dictionary = [@{@"userId":[self.user.userid stringValue]}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.openArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)browseSecret {
    USBrowseSecretProcess *process = [[USBrowseSecretProcess alloc] init];
    process.dictionary = [@{@"userId":[self.user.userid stringValue]}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.likeArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
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
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.user.backgroundPic]] placeholderImage:[UIImage imageNamed:@"m_xunmi"]];
    [self.view sendSubviewToBack:self.headerView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (self.currentSelect == 0) {
        return self.releaseArray.count;
    }else if (self.currentSelect == 1) {
        return self.openArray.count;
    }else {
        return self.likeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        USUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USER_MESSAGE_CELL" forIndexPath:indexPath];
        USER_TYPE type;
        if ([[self.user.userid stringValue] isEqualToString:USER_ID]) {
            type = OWN;
        }else{
            type = OTHER;
        }
        [cell changeUIByUser:type user:self.user];
        return cell;
    }
    USUserSecretCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USER_SECRET_CELL" forIndexPath:indexPath];
    USSecretListModel *model;
    switch (self.currentSelect) {
        case 0:
            model = self.releaseArray[indexPath.row];
            break;
        case 1:
            model = self.openArray[indexPath.row];
            break;
        case 2:
            model = self.likeArray[indexPath.row];
            break;
        default:
            break;
    }
    [cell changeUIByModel:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.currentSelect == 0) {
            ((UIButton *)self.aboutSecretBtnArray[0]).selected = YES;
            if (self.releaseArray.count == 0) {
                [self releaseSecretList];
            }
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
    switch (sender.tag) {
        case 0:
            [self releaseSecretList];
            break;
        case 1:
            [self openSecretList];
            break;
        case 2:
            [self browseSecret];
            break;
        default:
            break;
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
