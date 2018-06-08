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
#import "USMSubmitDifferentProcess.h"

@interface USMainLookingForDifferentVC()

@property (nonatomic, copy) NSString *picId;

@end

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
    
        //如果已经点击
       NSInteger isFrist = [[USER_DEFUALT objectForKey:@"isFristDifferent"] integerValue];
        if( isFrist == 1 ){
            
            [self.viewPrompt removeFromSuperview];
        }
        
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
        weakself.picId = model.picId;
        // 显示原图
        NSString *strOldPicUrl = IMAGEURL(model.oldPic, 0, 0);
        UIImage *oldImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strOldPicUrl];
        if( oldImage == nil ){
        
            // 下载图片
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:strOldPicUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                weakself.imageViewOriginal.image = image;
                weakself.imageViewSelect.image = image;
                
            }];
            
        }else{
            
            weakself.imageViewOriginal.image = oldImage;
            weakself.imageViewSelect.image = oldImage;
        }
        
        // 显示点击图片
        NSString *strPicUrl = IMAGEURL(model.pic, 0, 0);
        UIImage *picImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strPicUrl];
        if( picImage == nil ){
            
            // 下载图片
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:strPicUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                [weakself.buttonImageSelect setNormalImage:image];
                
            }];
            
        }else{
            
            [weakself.buttonImageSelect setNormalImage:picImage];
        }
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

// 找到不同 提交
- (void)requestSubmitDifferent{
    
    USMSubmitDifferentProcess *process = [[USMSubmitDifferentProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID,@"secretId":self.mainModel.secretId,@"picId":self.picId} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
        [self removeFromSuperview];
        
    } errorBlock:^(NSError *error) {
       
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

#pragma mark - 按钮事件
// 开始
- (IBAction)clickStart:(id)sender {
    
    [USER_DEFUALT setObject:@"1" forKey:@"isFristDifferent"];
    [USER_DEFUALT synchronize];
    [self.viewPrompt removeFromSuperview];
}
// 点击不同
- (IBAction)clickDifferent:(id)sender {
    
    self.buttonImageSelect.selected = YES;
    self.buttonImageSelect.userInteractionEnabled = NO;
    [self requestSubmitDifferent];
    
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
