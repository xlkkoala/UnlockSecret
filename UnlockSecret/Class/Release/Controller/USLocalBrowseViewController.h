//
//  USLocalBrowseViewController.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/6.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^BackBlock)(NSMutableArray *data);
@interface USLocalBrowseViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) BackBlock backBlock;

- (void)deleteSomeImageBack:(BackBlock)block;

@end
