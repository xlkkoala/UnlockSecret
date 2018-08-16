//
//  USGetImageProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/8/16.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USGetImageProcess.h"

@implementation USGetImageProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_GETIMAGE] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        NSInteger code = [response[@"data"][@"code"] integerValue];
        if (code == 200) {
            success(response[@"data"][@"data"]);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}

@end
