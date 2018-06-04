//
//  LoginHelper.h
//  UnlockSecret
//
//  Created by xlk on 2018/4/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USUser.h"

@interface LoginHelper : NSObject

+ (BOOL)isUserLogin;

+ (USUser *)currentUser;

@end
