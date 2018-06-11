//
//  USUserViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUserViewController.h"
#import "UIView+FrameTool.h"
#define HEADER_HEIGHT SCREEN_HEIGHT/2
@interface USUserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

@implementation USUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareHeaderView];
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT-40, 0, 0, 0);
    
    [self.view sendSubviewToBack:self.headerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USER_MESSAGE_CELL" forIndexPath:indexPath];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }
    return 40;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
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
