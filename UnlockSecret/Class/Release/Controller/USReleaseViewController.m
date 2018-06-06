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
static NSString *const Release_TextView_Cell     = @"Release_TextView_Cell";
static NSString *const Release_Image_Cell        = @"Release_Image_Cell";
static NSString *const Release_Info_Cell         = @"Release_Info_Cell";

@interface USReleaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ResponseTextEndChangeDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageDataArray;

@end

@implementation USReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)imageDataArray{
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
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

- (void)selectOrDeleteImage:(UIButton *)button {
    if ((button.tag == self.imageDataArray.count && self.imageDataArray.count != 9)) {
        UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
        imageController.delegate = self;
        imageController.allowsEditing = YES;
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
        NSLog(@"delete image");
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller
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