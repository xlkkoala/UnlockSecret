//
//  PuzzleView.h
//  UnlockSecret
//
//  Created by xlk on 2018/8/16.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleStatus.h"
#import "USMainModel.h"
typedef void(^PuzzleSuccessBlock)(void);

@interface PuzzleView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *referenceImage;//参考图片

@property (nonatomic, strong) PuzzleSuccessBlock puzzleBlock;
@property (nonatomic, strong) USMainModel *mainModel;
#pragma mark - 选项
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 矩阵阶数
@property (nonatomic, assign) NSInteger matrixOrder;
@property (nonatomic, assign) NSInteger algorithm;

#pragma mark - 状态
/// 当前游戏状态
@property (nonatomic, strong) PuzzleStatus *currentStatus;
/// 完成时的游戏状态
@property (nonatomic, strong) PuzzleStatus *completedStatus;

@end
