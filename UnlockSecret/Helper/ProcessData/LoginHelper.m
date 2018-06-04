//
//  LoginHelper.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "LoginHelper.h"

@implementation LoginHelper

+ (BOOL)isUserLogin{
    USUser *user = [XLKTool currentDataByPath:nil];
    if (!user) {
        return NO;
    }
    return YES;
}

+ (USUser *)currentUser{
    return [XLKTool currentDataByPath:nil];
}

@end
