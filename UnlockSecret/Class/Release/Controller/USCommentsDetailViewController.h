//
//  USCommentsDetailViewController.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/21.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseViewController.h"
#import "USCommentListModel.h"
@interface USCommentsDetailViewController : BaseViewController

@property (nonatomic, strong) USCommentListModel *comments;
@property (nonatomic, strong) NSString *secretId;

@end
