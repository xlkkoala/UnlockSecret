//
//  USM_LookingForDifferentVC.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBShapedButton.h"
#import "RCProgressView.h"
#import "USMainModel.h"

typedef void(^UnlockedSuccessBlock)(NSInteger index);
@interface USMainLookingForDifferentVC : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;
@property (weak, nonatomic) IBOutlet UIButton *buttonFocus;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOriginal;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelect;
@property (weak, nonatomic) IBOutlet UIView *viewPrompt;
@property (weak, nonatomic) IBOutlet OBShapedButton *buttonImageSelect;
@property (weak, nonatomic) IBOutlet UIButton *buttonError;
@property (weak, nonatomic) IBOutlet RCProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelCountdown;

@property (nonatomic, strong) USMainModel *mainModel;
@property (nonatomic, assign) NSInteger selectIndex;
// 解锁成功回调
@property (nonatomic, copy) UnlockedSuccessBlock unlockedSuccessBlock;


@end
