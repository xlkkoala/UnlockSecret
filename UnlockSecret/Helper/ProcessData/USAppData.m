//
//  USAppData.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/9.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USAppData.h"

static USAppData *_appData;

@implementation USAppData

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appData = [[USAppData alloc] init];
    });
    return _appData;
}



@end
