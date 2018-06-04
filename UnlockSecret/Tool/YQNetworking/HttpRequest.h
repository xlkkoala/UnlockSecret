//
//  HttpRequest.h
//  UnlockSecret
//
//  Created by xlk on 2018/3/22.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+CommonCryptor.h"
#import "JJTools.framework/Headers/NSString+Joker.h"

typedef void (^progress)(int64_t byteRead, int64_t totalBytes);
typedef void (^success)(id response);
typedef void (^error)(NSError *error);

@interface HttpRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSMutableDictionary *dictionary;


- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure;

- (NSMutableDictionary *)encrypt:(NSString*)data queryid:(NSString *)queryid;
@end
