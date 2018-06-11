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

static NSString *const Release_TextView_Cell     = @"Release_TextView_Cell";
static NSString *const Release_Image_Cell        = @"Release_Image_Cell";
static NSString *const Release_Info_Cell         = @"Release_Info_Cell";

@interface USReleaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ResponseTextEndChangeDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageDataArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
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
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        USReleaseTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Release_TextView_Cell forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1) {
        USReleaseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Release_Image_Cell forIndexPath:indexPath];
        cell.addImageBtn.tag = indexPath.row;
        [cell.addImageBtn addTarget:self action:@selector(selectOrDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row < self.imageDataArray.count) {
            [cell.addImageBtn setBackgroundImage:self.imageDataArray[indexPath.row] forState:UIControlStateNormal];
        }else{
            [cell.addImageBtn setBackgroundImage:nil forState:UIControlStateNormal];
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
    NSLog(@"%ld---%ld",(long)indexPath.section,indexPath.row);
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
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [self presentViewController:imageController animated:YES completion:nil];
        }];
        UIAlertAction *photoLibaray = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imageController animated:YES completion:nil];
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
    USOpenSecretViewController *vc = [RELEASE_STORYBOARD instantiateViewControllerWithIdentifier:@"OPEN_SECRET_ID"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
        [self releaseSecret];
    }
}

#pragma mark - 发布秘密

- (void)releaseSecret {
    
}

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
