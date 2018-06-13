//
//  USRegisterProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USRegisterProcess.h"

@implementation USRegisterProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_REGISTER] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        if ([response[@"data"][@"success"] isEqual:@1]) {
            USUser *user = [[USUser alloc] initWithDictionary:response[@"data"][@"user"]];
            [XLKTool saveDataByPath:user path:nil];
            success(user);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}

@end
