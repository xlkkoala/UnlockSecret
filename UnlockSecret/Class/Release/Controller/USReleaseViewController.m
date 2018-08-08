//
//  USReleaseViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USReleaseViewController.h"
#import "USReleaseTextCell.h"
#import "USReleaseImageCell.h"
#import "USReleaseInfoCell.h"
#import "USLocalBrowseViewController.h"
#import "USOpenSecretViewController.h"
#import "USUploadImageProcess.h"
#import <IJSImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "USNearAddressViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "USReleaseProcess.h"

static NSString *const Release_TextView_Cell     = @"Release_TextView_Cell";
static NSString *const Release_Image_Cell        = @"Release_Image_Cell";
static NSString *const Release_Info_Cell         = @"Release_Info_Cell";

@interface USReleaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ResponseTextEndChangeDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageDataArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) AMapPOI  *poi;
@end

@implementation USReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSMutableArray *)imageDataArray {
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        if (self.imageDataArray.count == 0) {
            return 1;
        }else if (self.imageDataArray.count == 9) {
            return self.imageDataArray.count;
        }else{
            return self.imageDataArray.count + 1 ;
        }
    }
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        USReleaseTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Release_TextView_Cell forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1) {
        USReleaseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Release_Image_Cell forIndexPath:indexPath];
        cell.addImageBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.addImageBtn.tag = indexPath.row;
        [cell.addImageBtn addTarget:self action:@selector(selectOrDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row < self.imageDataArray.count) {
            [cell.addImageBtn setBackgroundImage:self.imageDataArray[indexPath.row] forState:UIControlStateNormal];
            [cell.addImageBtn setImage:nil forState:UIControlStateNormal];
        }else{
            [cell.addImageBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.addImageBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        }
        return cell;
    }else {
        USReleaseInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Release_Info_Cell forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"贴个标签";
                break;
            case 1:
                cell.titleLabel.text = @"所在位置";
                break;
            case 2:
                cell.titleLabel.text = @"解锁后可看";
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 1) {
        // 选择地址
        USNearAddressViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectLocaitonVC"];
        vc.hidesBottomBarWhenPushed = YES;

        if (self.poi) {
            vc.oldPoi = self.poi;
        }
        __weak __typeof(self) weakSelf = self;
        [vc setSuccessBlock:^(AMapPOI *obj){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.poi = obj;
            USReleaseInfoCell *cell = (USReleaseInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
            if (obj) {
                if (obj.name.length > 0) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@·%@\n%@",self.poi.city,self.poi.name,self.poi.address];
                }else{
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",self.poi.city];
                }
            }else{
                cell.detailLabel.text = @"";
            }
        }];

        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 2) {
//        USOpenSecretViewController *vc = [RELEASE_STORYBOARD instantiateViewControllerWithIdentifier:@"OPEN_SECRET_ID"];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 140);
    } else if (indexPath.section == 1) {
        return CGSizeMake((SCREEN_WIDTH - 80)/3, (SCREEN_WIDTH - 60)/3);
    }else{
        return CGSizeMake(SCREEN_WIDTH - 40, 60);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return UIEdgeInsetsZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)textHaveTouchDone {
    [self.view endEditing:YES];
}

#pragma mark - 选择或者查看照片

- (void)selectOrDeleteImage:(UIButton *)button {
    if ((button.tag == self.imageDataArray.count && self.imageDataArray.count != 9)) {
        UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
        imageController.delegate = self;
        imageController.allowsEditing = NO;
        UIAlertController *actionCtrl = [UIAlertController alertControllerWithTitle:@"选择照片"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self isCanUseCamera] == NO) {
                [SVProgressHUD showInfoWithStatus:@"请在iPhone的""设置-隐私-相机""选项中允许寻秘访问你的相机"];
                return;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [self presentViewController:imageController animated:YES completion:nil];
        }];
        UIAlertAction *photoLibaray = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            if ([self isCanUsePhotos] == NO) {
//                [SVProgressHUD showInfoWithStatus:@"请在iPhone的""设置-隐私-照片""选项中允许寻秘访问你的手机相册"];
//                return;
//            }
            
            IJSImagePickerController *vc = [[IJSImagePickerController alloc] initWithMaxImagesCount:9 - self.imageDataArray.count columnNumber:4 pushPhotoPickerVc:YES];
            [self presentViewController:vc animated:YES completion:nil];
            
            [vc loadTheSelectedData:^(NSArray<UIImage *> *photos, NSArray<NSURL *> *avPlayers, NSArray<PHAsset *> *assets, NSArray<NSDictionary *> *infos, IJSPExportSourceType sourceType, NSError *error) {
                [self.imageDataArray addObjectsFromArray:photos];
                [self.collectionView reloadData];
            }];
        }];
        
        [actionCtrl addAction:cancle];
        [actionCtrl addAction:camera];
        [actionCtrl addAction:photoLibaray];
        [self presentViewController:actionCtrl animated:YES completion:nil];
        return;
    }else{
        NSLog(@"查看图片");
        [self performSegueWithIdentifier:@"LocalBrowseSegue" sender:button];
    }
}

- (BOOL)isCanUsePhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)isCanUseCamera {
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

#pragma mark - 照片的代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:NO completion:^{
        self.navigationController.navigationBarHidden = NO;
        if (image != nil) {
            [self.imageDataArray insertObject:image atIndex:self.imageDataArray.count];
            [self.collectionView reloadData];
        }
    }];
}

- (IBAction)releaseClick:(UIBarButtonItem *)sender {
    
    USReleaseTextCell *cell = (USReleaseTextCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    USReleaseInfoCell *infocell = (USReleaseInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    NSString *pic = @"";
    for (int i = 0; i < self.imageUrlArray.count; i ++) {
        if (i == self.imageUrlArray.count) {
            pic = [pic stringByAppendingString:self.imageUrlArray[i]];
        }else{
            pic = [pic stringByAppendingString:[NSString stringWithFormat:@"%@,",self.imageUrlArray[i]]];
        }
    }
    NSString *position = @"";
    NSString *address = @"";
    if (self.poi) {
        position = [NSString stringWithFormat:@"%f,%f",self.poi.location.latitude,self.poi.location.longitude];
        address = [NSString stringWithFormat:@"%@·%@\n%@",self.poi.city,self.poi.name,self.poi.address];
    }
    
    if ([cell.secretTextView.text isEqualToString:@""] || cell.secretTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入内容"];
        return;
    }else if ([cell.titleTF.text isEqualToString:@""] || cell.titleTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入标题"];
        return;
    }
    
    // 如果有选择图片，首先上传图片
    if (self.imageDataArray.count > 0) {
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
        dispatch_group_t group = dispatch_group_create();
        for (int i = 0; i < self.imageDataArray.count; i ++) {
            dispatch_group_async(group, queue, ^{
                [self uploadImage:self.imageDataArray[i]];
            });
        }
        dispatch_group_notify(group, queue, ^{
            NSLog(@"over");
        });
    }else {
        [self releaseSecretByContent:cell.secretTextView.text title:cell.titleTF.text label:infocell.detailLabel.text pic:pic positon:position address:address];
    }
}

#pragma mark - 发布秘密

- (void)releaseSecretByContent:(NSString *)content title:(NSString *)title label:(NSString *)label pic:(NSString *)pic positon:(NSString *)position address:(NSString *)address{
    
    USReleaseProcess *process = [[USReleaseProcess alloc] init];
    process.dictionary =[@{@"content":content,@"title":title,@"label":label,@"pic":pic,@"userId":USER_ID,@"position":position,@"address":address}mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        [self methodsInMainQueue:^{
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [self initAllUI];
        }]; 
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 重新初始化页面

- (void)initAllUI {
    USReleaseTextCell *cell = (USReleaseTextCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.secretTextView.text = @"";
    cell.titleTF.text = @"";
    USReleaseInfoCell *infocell = (USReleaseInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    infocell.detailLabel.text = @"";
    [self.imageDataArray removeAllObjects];
    [self.imageUrlArray removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - 取消按钮

- (IBAction)cancleClick:(id)sender {
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = [USAppData instance].currentItenIndex?[USAppData instance].currentItenIndex:0;
}

#pragma mark - 上传图片

- (void)uploadImage:(UIImage *)image {
    USUploadImageProcess *uploadProcess = [[USUploadImageProcess alloc] init];
    [uploadProcess uploadImageBySource:image withProcess:^(int64_t byteRead, int64_t totalBytes) {
        
    } wtihSuccess:^(id response) {
        NSString *url = response;
        [self.imageUrlArray addObject:url];
        if (self.imageUrlArray.count == self.imageDataArray.count) {
            USReleaseTextCell *cell = (USReleaseTextCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            USReleaseInfoCell *infocell = (USReleaseInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            NSString *pic = @"";
            for (int i = 0; i < self.imageUrlArray.count; i ++) {
                if (i == self.imageUrlArray.count) {
                    pic = [pic stringByAppendingString:self.imageUrlArray[i]];
                }else{
                    pic = [pic stringByAppendingString:[NSString stringWithFormat:@"%@,",self.imageUrlArray[i]]];
                }
            }
            NSString *position = @"";
            NSString *address = @"";
            if (self.poi) {
                position = [NSString stringWithFormat:@"%f,%f",self.poi.location.latitude,self.poi.location.longitude];
                address = [NSString stringWithFormat:@"%@·%@\n%@",self.poi.city,self.poi.name,self.poi.address];
            }
            [self releaseSecretByContent:cell.secretTextView.text title:cell.titleTF.text label:infocell.detailLabel.text pic:pic positon:position address:address];
        }
    } withError:^(NSError *error) {
        
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton *button = (UIButton *)sender;
    USLocalBrowseViewController *vc = segue.destinationViewController;
    vc.dataArray = self.imageDataArray;
    vc.currentIndex = button.tag;
    [vc deleteSomeImageBack:^(NSMutableArray *data) {
        self.imageDataArray = data;
        [self.collectionView reloadData];
    }];
}

@end
