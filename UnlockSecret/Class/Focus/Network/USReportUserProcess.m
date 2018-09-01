//
//  USReportUserProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/9/1.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USReportUserProcess.h"

@implementation USReportUserProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_REPORT_USER] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        int code = [response[@"code"] intValue];
        if (code == 200) {
            success(response);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}


@end
