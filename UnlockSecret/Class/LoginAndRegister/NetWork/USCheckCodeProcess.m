//
//  USCheckCodeProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USCheckCodeProcess.h"

@implementation USCheckCodeProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_CHECK_CODE] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        if ([response[@"data"][@"success"] isEqual:@1]) {
            success(response);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取验证码失败!"];
        failure(error);
    }];
}

@end