//
//  USMainModel.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/6.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USMainModel : NSObject

@property (nonatomic, copy) NSString *comment_count;
// 0未关注 1已关注
@property (nonatomic, assign) int isAttention;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *open_count;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *praise_count;
@property (nonatomic, copy) NSString *secretId;
@property (nonatomic, copy) NSString *system_pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;
// 是否打开过 0未打开 1打开
@property (nonatomic, assign) int isOpen;
@property (nonatomic, copy) NSString *no_pic;
@property (nonatomic, copy) NSString *open_pic;


@end
