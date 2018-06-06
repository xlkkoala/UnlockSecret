//
//  USLocalBrowseViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/6.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USLocalBrowseViewController.h"

@interface USLocalBrowseViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation USLocalBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger i =  scrollView.contentOffset.x/SCREEN_WIDTH;
    self.title = [NSString stringWithFormat:@"%ld/%ld",i + 1,self.dataArray.count];
    self.currentIndex = i;
    NSLog(@"%ld",(long)i);
}

- (void)creatScrollView {
    self.scrollView.contentSize = CGSizeMake(self.dataArray.count*SCREEN_WIDTH, 0);
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (_IPHONE_X?84:64))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.dataArray[i];
        [self.scrollView addSubview:imageView];
    }
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex + 1,self.dataArray.count];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.currentIndex, 0) animated:NO];
}

- (IBAction)deleteClick:(id)sender {
    UIAlertController *actionCtrl = [UIAlertController alertControllerWithTitle:@"要删除这张照片吗？"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self methodsInMainQueue:^{
            if (self.dataArray.count != 1) {
                [self.dataArray removeObjectAtIndex:self.currentIndex];
                for (UIView *view in self.scrollView.subviews) {
                    [view removeFromSuperview];
                }
                if (self.currentIndex == self.dataArray.count) {
                    self.currentIndex = self.currentIndex - 1;
                }
                [self creatScrollView];
            }else{
                [self.dataArray removeAllObjects];
                self.backBlock(self.dataArray);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionCtrl addAction:delete];
    [actionCtrl addAction:cancle];
    [self presentViewController:actionCtrl animated:YES completion:nil];
}

- (void)deleteSomeImageBack:(BackBlock)block{
    if (self.backBlock) {
        self.backBlock = nil;
    }
    self.backBlock = block;
}

- (void)backClick{
    self.backBlock(self.dataArray);
    [self.navigationController popViewControllerAnimated:YES];
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
