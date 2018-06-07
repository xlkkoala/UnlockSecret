//
//  USM_LookingForDifferentVC.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMainLookingForDifferentVC.h"
#import "USMLookingForDifferentProcess.h"
#import "USMLookingDiffModel.h"
#import <SDWebImageManager.h>

@implementation USMainLookingForDifferentVC

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( self ){
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"USM_LookingForDifferentVC" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        self.progressView.progressBgColor = ColorFromRGB(217, 217, 217);
        self.progressView.progressBarColor = ColorFromRGB(46, 182, 24);
        self.progressView.progress = 0.8;
        
        [self getLookingForDifferentData];
        
    }
    
    return self;
}

//获取找不同图片
- (void)getLookingForDifferentData{
    
    __weak typeof(self) weakself = self;
    
    USMLookingForDifferentProcess *process = [[USMLookingForDifferentProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        USMLookingDiffModel *model = (USMLookingDiffModel *)response;
//        [weakself.imageViewOriginal sd_setImageWithURL: [NSURL URLWithString:IMAGEURL(model.oldPic, 0, 0)]];
//        [weakself.imageViewSelect sd_setImageWithURL: [NSURL URLWithString:IMAGEURL(model.oldPic, 0, 0)]];
        
        NSString *strImageUrl = IMAGEURL(model.oldPic, 0, 0);
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:strImageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            weakself.imageViewOriginal.image = image;
            weakself.imageViewSelect.image = image;
            
        }];
        
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

- (void)downloadPhoto{
    

        // 下载头像
        NSString *str = @"";
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:str];
//    [SDWebImageManager sharedManager] loa];
        if( image == nil ){
            
//            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                CLLog(@"下载进度--------receivedSize %ld    receivedSize- %ld",receivedSize,expectedSize);
//
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//
//                CLLog(@"缓存完成----------%ld   error:%@",cacheType,error.localizedDescription);
//
//            }];
            
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
            }];
            
        }
    
}


#pragma mark - 按钮事件

// 点击不同
- (IBAction)clickDifferent:(id)sender {
    
    self.buttonImageSelect.selected = YES;
    
}
// 不想解
- (IBAction)clickClose:(id)sender {
    
    [self removeFromSuperview];
}
// 微信朋友圈求助
- (IBAction)clickWeChatFriends:(id)sender {
}
// 微信好友求助
- (IBAction)clickWeChat:(id)sender {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
