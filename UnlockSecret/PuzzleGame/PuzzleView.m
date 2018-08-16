//
//  PuzzleView.m
//  UnlockSecret
//
//  Created by xlk on 2018/8/16.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "PuzzleView.h"
#import "USOpenSecretViewController.h"
#import "USMSubmitDifferentProcess.h"
#import "USGetImageProcess.h"

@implementation PuzzleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( self ){
        self = [[[NSBundle mainBundle] loadNibNamed:@"PuzzleView" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.matrixOrder = 3;
        self.algorithm = 3;
        [self requestData];
    }
    return self;
}

- (void)requestData {
    USGetImageProcess *process = [[USGetImageProcess alloc] init];
    [process getMessageHandleWithSuccessBlock:^(id response) {
        NSDictionary *dic = (NSDictionary *)response;
        NSString *url = IMAGEURL(dic[@"pic"], 0, 0);
        NSLog(@"%@",url);
        self.image = [self getImageFromURL:url];
        self.referenceImage.image = self.image;
        self.completedStatus = [self.currentStatus  copyStatus];
        self.currentStatus.emptyIndex = 1;
        [self onShuffleButton];
    } errorBlock:^(NSError *error) {
        
    }];
}



-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}


- (void)onShuffleButton {
    if (self.currentStatus.emptyIndex < 0) {
        return;
    }
    NSLog(@"打乱顺序：当前为%@阶方阵, 随机移动%@步", @(self.matrixOrder), @(self.matrixOrder * self.matrixOrder * 10));
    [self.currentStatus shuffleCount:self.matrixOrder * self.matrixOrder * 10];
    [self reloadWithStatus:self.currentStatus];
    self.currentStatus.emptyIndex = -1;
}

- (void)reloadWithStatus:(PuzzleStatus *)status {
    [UIView animateWithDuration:0.25 animations:^{
        CGSize size = status.pieceArray.firstObject.frame.size;
        NSInteger index = 0;
        for (NSInteger row = 0; row < self.matrixOrder; ++ row) {
            for (NSInteger col = 0; col < self.matrixOrder; ++ col) {
                PuzzlePiece *piece = status.pieceArray[index ++];
                piece.frame = CGRectMake(col * size.width, row * size.height, size.width, size.height);
            }
        }
    }];
}

/// 重置游戏
- (void)onResetButton:(UIButton *)sender {
    if (!self.image) {
        return;
    }
    
    if (self.currentStatus) {
        [self.currentStatus removeAllPieces];
    }
    self.currentStatus = [PuzzleStatus statusWithMatrixOrder:self.matrixOrder image:self.image];
    [self.currentStatus.pieceArray enumerateObjectsUsingBlock:^(PuzzlePiece * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(onPieceTouch:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.completedStatus = nil;
    [self showCurrentStatusOnView:self.bgView];
    self.completedStatus = [self.currentStatus  copyStatus];
}

/// 点击方块
- (void)onPieceTouch:(PuzzlePiece *)piece {
    PuzzleStatus *status = self.currentStatus;
    NSInteger pieceIndex = [status.pieceArray indexOfObject:piece];
    
    
    // 挖空一格
    if (status.emptyIndex < 0) {
        // 所选方块成为空格
        [UIView animateWithDuration:0.25 animations:^{
            piece.alpha = 0.5;
        }];
        status.emptyIndex = pieceIndex;
        
        return;
    }else if (status.emptyIndex == pieceIndex) {
        piece.alpha = 1;
        status.emptyIndex = -1;
        return;
    }
    
    if (![status canMoveToIndex:pieceIndex]) {
        //        NSLog(@"无法移动，target index:%@",  @(pieceIndex));
        //        return;
        [UIView animateWithDuration:0.25 animations:^{
            piece.alpha = 0.5;
        }];
        PuzzlePiece *empty = status.pieceArray[status.emptyIndex];
        empty.alpha = 1;
        status.emptyIndex = pieceIndex;
        return;
    }
    
    [status moveToIndex:pieceIndex];
    [self reloadWithStatus:self.currentStatus];

    // 完成一次移动
    if ([status equalWithStatus:self.completedStatus]) {
        USMSubmitDifferentProcess *process = [[USMSubmitDifferentProcess alloc] init];
        process.dictionary = [@{@"userId":USER_ID,@"secretId":self.mainModel.secretId} mutableCopy];
        [process getMessageHandleWithSuccessBlock:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"打开成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
                self.puzzleBlock();
                USOpenSecretViewController *vc = [RELEASE_STORYBOARD instantiateViewControllerWithIdentifier:@"OPEN_SECRET_ID"];
                vc.secretId = self.mainModel.secretId;
                
                UITabBarController *tabbarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                UINavigationController *nav = tabbarController.selectedViewController;
                [nav pushViewController:vc animated:YES];
            });
        } errorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"打开失败"];
        }];
    }
}


- (void)setMatrixOrder:(NSInteger)matrixOrder {
    if (matrixOrder < 3 || matrixOrder > 5) {
        return;
    }
    _matrixOrder = matrixOrder;
    [self onResetButton:nil];
}


- (void)setImage:(UIImage *)image {
    _image = image;
    [self onResetButton:nil];
}

- (void)showCurrentStatusOnView:(UIView *)view {
    CGFloat size = CGRectGetWidth(view.bounds) / self.matrixOrder;
    NSInteger index = 0;
    for (NSInteger row = 0; row < self.matrixOrder; ++ row) {
        for (NSInteger col = 0; col < self.matrixOrder; ++ col) {
            PuzzlePiece *piece = self.currentStatus.pieceArray[index ++];
            piece.frame = CGRectMake(col * size, row * size, size, size);
            [view addSubview:piece];
        }
    }
}
- (IBAction)canclePuzzle:(id)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
