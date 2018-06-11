//
//  USAppData.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/9.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USAppData : NSObject

@property (nonatomic, assign) NSInteger currentItenIndex;
@property (nonatomic, strong) NSString *backGroundTime;

+ (instancetype)instance;

@end
