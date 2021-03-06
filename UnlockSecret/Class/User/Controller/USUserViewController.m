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
#import "USOpenSecretViewController.h"
#import "USGetUserMessage.h"
#import "USUploadImageProcess.h"
#import "USEditPersonalInfoProcess.h"

#define HEADER_HEIGHT SCREEN_WIDTH

@interface USUserViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *btnBackgroundPic;
@property (strong, nonatomic) IBOutlet UIView *secretView;//session （发布，浏览，取消）
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *aboutSecretBtnArray;//session button （发布，浏览，取消）
@property (nonatomic, assign) NSInteger currentSelect;// 当前选择（发布/浏览/取消）

@property (nonatomic, assign) BOOL isTabbar;
@property (nonatomic, strong) NSMutableArray *releaseArray;
@property (nonatomic, strong) NSMutableArray *openArray;
@property (nonatomic, strong) NSMutableArray *likeArray;

@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@end

@implementation USUserViewController

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
    
    self.isTabbar = YES;
    NSLog(@"backgroundPic------- %@",[LoginHelper currentUser].backgroundPic);
    [self prepareHeaderView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _IPHONE_X?SCREEN_HEIGHT-83:SCREEN_HEIGHT-49);
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT-60, 0, 0, 0);
    self.tableView.estimatedRowHeight = 300;
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:!self.isTabbar];
    self.isTabbar = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUserMessage];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark --- getUserMessage

- (void)getUserMessage {
    [SVProgressHUD show];
    USGetUserMessage *process = [[USGetUserMessage alloc] init];
    process.dictionary = [@{@"userId":self.userId?self.userId:USER_ID,@"nowId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.user = response;
        [self releaseSecretList];
        // 加载顶部背景图
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:IMAGEURL([LoginHelper currentUser].backgroundPic, 0, 0)] placeholderImage:BACKGOUND_IMAGE];
        [SVProgressHUD dismiss];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark --- 发布秘密列表

- (void)releaseSecretList {
    USReleaseListProcess *process = [[USReleaseListProcess alloc] init];
    process.dictionary = [@{@"userId":[self.user.userid stringValue]}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.releaseArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark --- 打开秘密列表

- (void)openSecretList {
    USOpenSecretListProcess *process = [[USOpenSecretListProcess alloc] init];
    process.dictionary = [@{@"userId":[self.user.userid stringValue]}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.openArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark --- 关注秘密列表

- (void)browseSecret {
    USBrowseSecretProcess *process = [[USBrowseSecretProcess alloc] init];
    process.dictionary = [@{@"userId":[self.user.userid stringValue]}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        self.likeArray = response;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark --- 更新headerview

- (void)prepareHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:self.headerView];
    self.headerImageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
    self.headerImageView.contentMode = UIViewContentModeScaleToFill;
    self.headerImageView.clipsToBounds = YES;
    [_headerView addSubview:_headerImageView];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(self.user.backgroundPic, 0, 0)] placeholderImage:BACKGOUND_IMAGE];
    [self.view sendSubviewToBack:self.headerView];
    
    self.btnBackgroundPic = [[UIButton alloc] initWithFrame:CGRectMake(0, -HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT-85)];
    [self.btnBackgroundPic addTarget:self action:@selector(sheetImagePickerController) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.btnBackgroundPic];
}

#pragma nark - tableview data source

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
    [cell changeUIByModel:[self selectCurrentModelByRow:indexPath.row]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.isTabbar = NO;
    if (indexPath.section == 1) {
        USOpenSecretViewController *vc = [RELEASE_STORYBOARD instantiateViewControllerWithIdentifier:@"OPEN_SECRET_ID"];
        vc.secretId = [self selectCurrentModelByRow:indexPath.row].secretId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    self.btnBackgroundPic.height = self.headerView.height-85;
    
    
    
    
}

#pragma mark --- 切换秘密列表

- (USSecretListModel *)selectCurrentModelByRow:(NSInteger)row {
    USSecretListModel *model;
    switch (self.currentSelect) {
        case 0:
            model = self.releaseArray[row];
            break;
        case 1:
            model = self.openArray[row];
            break;
        case 2:
            model = self.likeArray[row];
            break;
        default:
            break;
    }
    return model;
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

#pragma mark --- 选择背景图片

- (void)sheetImagePickerController{
    
    __weak typeof(self) myself=self;
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:alertActionCancel];
    
    UIAlertAction *alertActionTPictures = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            myself.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [myself presentViewController:myself.imagePickerController animated:YES completion:NULL];
        }else{
            [SVProgressHUD showErrorWithStatus:@"照相机不可用"];
        }
        
    }];
    [alertViewController addAction:alertActionTPictures];
    
    UIAlertAction *alertActionPhotoAlbum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            myself.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [myself presentViewController:myself.imagePickerController animated:YES completion:NULL];
        }
    }];
    [alertViewController addAction:alertActionPhotoAlbum];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self upLoadImage:image];
}

- (void)upLoadImage:(UIImage *)image{
    
    [SVProgressHUD show];
    USUploadImageProcess *uploadProcess = [[USUploadImageProcess alloc] init];
    [uploadProcess uploadImageBySource:image withProcess:^(int64_t byteRead, int64_t totalBytes) {
        
    } wtihSuccess:^(id response) {
        NSLog(@"----------%@",response);
        USUser *user = [LoginHelper currentUser];
        user.backgroundPic = response;
        [XLKTool saveDataByPath:user path:nil];
        [self reuquestSubmitPic:response image:image];
        
    } withError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
// 提交资料
- (void)reuquestSubmitPic:(NSString *)pic image:(UIImage *)image{
    USEditPersonalInfoProcess *editProcess = [[USEditPersonalInfoProcess alloc] init];
    editProcess.dictionary = @{@"id":USER_ID,@"background_pic":pic}.mutableCopy;
    [editProcess getMessageHandleWithSuccessBlock:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            self.headerImageView.image = image;
        });
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark ---UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.isTabbar = NO;
}


@end
