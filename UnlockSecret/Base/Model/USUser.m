//
//  USUser.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/13.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUser.h"
#import <objc/runtime.h>
#import "Serialization.h"
@implementation USUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.attentionCount = [self valueForKey:@"attentionCount" type:[NSNumber class]];
        self.browseCount = [self valueForKey:@"browseCount" type:[NSNumber class]];
        self.praiseCount = [self valueForKey:@"praiseCount" type:[NSNumber class]];
        self.fans = [self valueForKey:@"fans" type:[NSNumber class]];
        self.openCount = [self valueForKey:@"openCount" type:[NSNumber class]];
        self.publishCount = [self valueForKey:@"publishCount" type:[NSNumber class]];
        self.birthday = [self valueForKey:@"birthday" type:[NSString class]];
        self.backgroundPic = [self valueForKey:@"backgroundPic" type:[NSString class]];
        self.createTime = [self valueForKey:@"createTime" type:[NSNumber class]];
        self.ddescription = [self valueForKey:@"description" type:[NSString class]];
        self.name = [self valueForKey:@"name" type:[NSString class]];
        self.password = [self valueForKey:@"password" type:[NSString class]];
        self.phone = [self valueForKey:@"phone" type:[NSString class]];
        self.photo = [self valueForKey:@"photo" type:[NSString class]];
//        self.photo = [NSString stringWithFormat:@"%@%@&w=0&h=0",PICTUREHOST,self.photo];
        self.userid = [self valueForKey:@"id" type:[NSNumber class]];
        self.sex = [self valueForKey:@"sex" type:[NSNumber class]];
    }
    return self;
}

SERIALIZATION()

@end
