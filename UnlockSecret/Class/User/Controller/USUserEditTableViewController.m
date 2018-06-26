//
//  USUserEditTableViewController.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/21.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUserEditTableViewController.h"
#import "USUploadImageProcess.h"

@interface USUserEditTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@end

@implementation USUserEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    btnSave.layer.cornerRadius = 5;
    [btnSave setNormalTitle:@"保存"];
    [btnSave setNormalTitleColor:UIColor.whiteColor];
    [btnSave.titleLabel setFont: [UIFont systemFontOfSize:14]];
    btnSave.backgroundColor = UIColor.redColor;
    [btnSave addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
     self.navigationItem.rightBarButtonItem = item;
    
    [self.imageViewHeader setCornerRadius:40];
}

- (void)clickSave{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickHeader:(id)sender {
    
    [self sheetImagePickerController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return 160;
            break;
        case 4:
            return 100;
            break;
            
        default:
            break;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( indexPath.row == 2 ){
        
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionCanel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alerController addAction:actionCanel];
        
        UIAlertAction *actionMan = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alerController addAction:actionMan];
        
        UIAlertAction *actionWoman = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alerController addAction:actionWoman];
        
        [self presentViewController:alerController animated:YES completion:nil];
    }
}

// 选择头像
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
    
    //设置image的尺寸
//    image = [[UtilityClass sharedInstance] imageWithImage:image scaledToSize:CGSizeMake(image.size.width, image.size.height)];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imageViewHeader.image = image;
    //    NSData *data= UIImagePNGRepresentation(image);
    NSData *data1=UIImageJPEGRepresentation(image, 0.8);
    
    [self upLoadImage:image];
    
}

- (void)upLoadImage:(UIImage *)image{
    
    USUploadImageProcess *uploadProcess = [[USUploadImageProcess alloc] init];
    [uploadProcess uploadImageBySource:image withProcess:^(int64_t byteRead, int64_t totalBytes) {
        
    } wtihSuccess:^(id response) {
        
        NSLog(@"----------%@",response);
        
    } withError:^(NSError *error) {
       
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

#pragma mark-------------
#pragma mark -------------UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.navigationController popViewControllerAnimated:YES];
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
