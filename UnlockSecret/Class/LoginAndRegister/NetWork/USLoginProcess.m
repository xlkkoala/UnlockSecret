//
//  USLoginProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/27.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USLoginProcess.h"
@implementation USLoginProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_LOGIN] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        if ([response[@"data"][@"code"] isEqual:@200]) {
            USUser *user = [[USUser alloc] initWithDictionary:response[@"data"][@"data"]];
            [XLKTool saveDataByPath:user path:nil];
            success(user);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
        failure(error);
    }];
}

@end
