//
//  USSecretHeaderView.h
//  HeaderView
//
//  Created by xlk on 2018/6/7.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USSecretDetailModel.h"
typedef void (^ClickHeaderBack)(void);
@interface USSecretHeaderView : UIView

@property (nonatomic, strong) USSecretDetailModel *model;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *headImgae;
- (instancetype)init;

- (void)creatMessage:(USSecretDetailModel *)model;

@end
