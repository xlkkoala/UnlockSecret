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
#import "USMainFocusProcess.h"

#define isFristDifferent @"isFristDifferent"

@interface USMainLookingForDifferentVC()

@property (nonatomic, copy) NSString *picId;
@property (nonatomic, strong) USMLookingDiffModel *modelDiff;
@property (nonatomic, assign) long countdown;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *currentTime;

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
       NSInteger isFrist = [[USER_DEFUALT objectForKey:isFristDifferent] integerValue];
        if( isFrist == 1 ){
            
            [self.viewPrompt removeFromSuperview];
        }
        self.currentTime = [XLKTool getNowTimeTimestamp];
        [USAppData instance].backGroundTime = [XLKTool getNowTimeTimestamp];
        [[USAppData instance] addObserver:self forKeyPath:@"backGroundTime" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}

- (void)setMainModel:(USMainModel *)mainModel{
    
    _mainModel = mainModel;
    [self.imageViewHeader sd_setImageWithURL:[NSURL URLWithString:IMAGEURL(mainModel.photo, 150, 150)] placeholderImage:DEFAULT_IMAGE_HEADER];
    self.buttonFocus.hidden = mainModel.isAttention;
    if( [StringValue(USER_ID) isEqualToString:StringValue(mainModel.uid)] ){
        
        self.buttonFocus.hidden = YES;
    }
}

#pragma mark - 数据请求
//获取找不同图片
- (void)getLookingForDifferentData{
    
    __weak typeof(self) weakself = self;
    
    USMLookingForDifferentProcess *process = [[USMLookingForDifferentProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        weakself.modelDiff = (USMLookingDiffModel *)response;
        weakself.picId = weakself.modelDiff.picId;
        // 显示原图
        NSString *strOldPicUrl = IMAGEURL(weakself.modelDiff.oldPic, 0, 0);
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
        NSString *strPicUrl = IMAGEURL(weakself.modelDiff.pic, 0, 0);
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
        
        weakself.countdown = weakself.modelDiff.sumTime;
        [weakself showSecond];
        //如果已经点击
        NSInteger isFrist = [[USER_DEFUALT objectForKey:isFristDifferent] integerValue];
        if( isFrist == 1 ){
            
            [weakself secondBtnAction];
        }
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

// 找到不同 提交
- (void)requestSubmitDifferent{
    
    if( !([StringValue(self.picId) isEqualToString:@"<null>"]  || [NSString isNull:self.picId])){
        
        __weak typeof(self) weakself = self;
        USMSubmitDifferentProcess *process = [[USMSubmitDifferentProcess alloc] init];
        process.dictionary = [@{@"userId":USER_ID,@"secretId":self.mainModel.secretId,@"picId":self.picId} mutableCopy];
        [process getMessageHandleWithSuccessBlock:^(id response) {
            
            [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
            [weakself removeFromSuperview];
            weakself.unlockedSuccessBlock(weakself.selectIndex);
            
        } errorBlock:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            
        }];
    }
    
}
//关注 type   1 添加  2为取消关注
- (void)requestFocusType:(NSString *)type attentionId:(NSString *)attentionId{
    
    [SVProgressHUD showWithStatus:nil];
    USMainFocusProcess *process = [[USMainFocusProcess alloc] init];
    process.dictionary = [@{@"userId":USER_ID,@"type":type,@"attentionId":attentionId} mutableCopy];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        
        self.buttonFocus.hidden = YES;
        [SVProgressHUD showSuccessWithStatus:@"已关注"];
        // 通知首页刷新列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONFOCUSREFRESH" object:attentionId];
        
    } errorBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

#pragma mark - 按钮事件
- (IBAction)clickFocus:(id)sender {
    
    [self requestFocusType:@"1" attentionId:self.mainModel.uid];
}
// 开始
- (IBAction)clickStart:(id)sender {
    
    [USER_DEFUALT setObject:@"1" forKey:isFristDifferent];
    [USER_DEFUALT synchronize];
    [self.viewPrompt removeFromSuperview];
    [self secondBtnAction];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    long long newTime = [[change objectForKey:@"new"] longLongValue];
    long long oldTime = [self.currentTime longLongValue];
    
    long long time = newTime - oldTime;
    NSLog(@"background time ---- %lld-%lld=%lld",newTime,oldTime,time);
    NSLog(@"remaining  time ---- %d - %lld = %lld",300,time,300 -  time);
    if (300 -  time > 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.countdown = 300 -  time;
        [self secondBtnAction];
    }else{
        self.countdown = 0;
        [self secondBtnAction];
        NSLog(@"over");
    }
    
    
}

// 点击不同
- (IBAction)clickDifferent:(id)sender {
    
//    self.buttonImageSelect.selected = YES;
    self.buttonImageSelect.userInteractionEnabled = NO;
    self.buttonError.userInteractionEnabled = NO;
    [self requestSubmitDifferent];
}
- (IBAction)clickError:(id)sender {
    
    self.countdown -= self.modelDiff.cutTime;
    
}
// 不想解
- (IBAction)clickClose:(id)sender {
    [[USAppData instance] removeObserver:self forKeyPath:@"backGroundTime"];
    [self removeFromSuperview];
}
// 微信朋友圈求助
- (IBAction)clickWeChatFriends:(id)sender {
}
// 微信好友求助
- (IBAction)clickWeChat:(id)sender {
}

#pragma mark - 定时器

- (void)secondBtnAction{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}
//定时操作
- (void)handleTimer {
    
    if (self.countdown <= 0) {
       
        self.countdown = 0;
        [self.timer invalidate];
        
    } else {
    
    }
    [self showSecond];
    self.countdown--;
}

- (void)showSecond{
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.countdown/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.countdown%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.countdown%60];
    
    self.labelCountdown.text = StringFormat(@"%@:%@:%@",str_hour,str_minute,str_second);
    self.progressView.progress = self.countdown*1.0/self.modelDiff.sumTime*1.0;
    if( self.progressView.progress > 0.2  && self.progressView.progress < 0.5 ){
        
        self.progressView.progressBarColor = [UIColor orangeColor];
    }else if( self.progressView.progress <= 0.2  ){
        
        self.progressView.progressBarColor = [UIColor redColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
