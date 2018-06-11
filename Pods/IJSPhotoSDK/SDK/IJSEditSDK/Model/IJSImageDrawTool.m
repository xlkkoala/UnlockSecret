//
//  IJSImageDrawTool.m
//  IJSImageEditSDK
//
//  Created by shan on 2017/7/14.
//  Copyright © 2017年 shanshen. All rights reserved.
//

#import "IJSImageDrawTool.h"
#import "IJSExtension.h"
#import "IJSIPanDrawingView.h"

@interface IJSImageDrawTool ()

@end

@implementation IJSImageDrawTool
#pragma mark 重写父类的方法
- (instancetype)initToolWithViewController:(IJSImageEditController *)controller
{
    self = [super initToolWithViewController:controller];
    if (self)
    {
        self.editorController = controller;
        self.allLineArr = [NSMutableArray array];
        [self cleanupTool];
        [self setupTool];
    }
    return self;
}

- (void)didFinishHandleWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [self.panDrawingView didFinishHandleWithCompletionBlock:completionBlock];
}

- (void)cleanupTool
{
    self.editorController.backImageView.userInteractionEnabled = NO;
    self.editorController.backScrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGesture.enabled = NO;
}

- (void)setupTool
{
    //初始化数据

    self.originalImageSize = self.editorController.backImageView.image.size;
    self.drawingView = self.editorController.drawingView;
    self.drawingView.userInteractionEnabled = YES;                  // 添加在imageview上的需要打开imageview的交互
    self.drawingView.layer.shouldRasterize = YES;                   // 栅格化,现在默认就是yes
    self.drawingView.layer.minificationFilter = kCAFilterTrilinear; //缩小筛选器kCAFilterLinear 更加细

    self.editorController.backScrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editorController.backScrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editorController.backScrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    self.panDrawingView.hidden = NO;
}

- (IJSIPanDrawingView *)panDrawingView
{
    if (_panDrawingView == nil)
    {
        IJSIPanDrawingView *panDrawingView = [[IJSIPanDrawingView alloc] initWithFrame:self.editorController.backImageView.bounds];
        panDrawingView.center = self.drawingView.superview.center;
        panDrawingView.editorController = self.editorController;
        [self.drawingView addSubview:panDrawingView];
        _panDrawingView = panDrawingView;
        __weak typeof(self) weakSelf = self;
        //绘画中
        panDrawingView.panDrawingViewdrawingCallBack = ^(BOOL isDrawing) {
            if (weakSelf.drawingCallBack)
            {
                weakSelf.drawingCallBack(YES);
            }
        };
        //画板单机
        panDrawingView.panDrawingViewDidTap = ^{
            if (weakSelf.drawToolDidTap)
            {
                weakSelf.drawToolDidTap();
            }
        };
        // 绘制结束
        panDrawingView.panDrawingViewEndDrawCallBack = ^(BOOL isEndDraw) {
            if (weakSelf.drawEndCallBack)
            {
                weakSelf.drawEndCallBack(isEndDraw);
            }
        };
    }
    return _panDrawingView;
}

// 撤销最后的绘制
- (void)cleanLastDrawPath
{
    [self.panDrawingView cleanLastDrawPath];
}
/// 绘制
- (void)drawLine {}
@end
