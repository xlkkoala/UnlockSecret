//
//  USUser.h
//  UnlockSecret
//
//  Created by xlk on 2018/4/13.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseModel.h"

@interface USUser : BaseModel<NSCopying,NSCoding>

@property (nonatomic, strong) NSNumber *attentionCount;//关注总数
@property (nonatomic, strong) NSString *backgroundPic;
@property (nonatomic, strong) NSNumber *browseCount;
@property (nonatomic, strong) NSNumber *fans;
@property (nonatomic, strong) NSNumber *praiseCount;
@property (nonatomic, strong) NSNumber *openCount;//打开总数
@property (nonatomic, strong) NSNumber *publishCount;//发布总数
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSString *ddescription;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSNumber *attention;


@end
