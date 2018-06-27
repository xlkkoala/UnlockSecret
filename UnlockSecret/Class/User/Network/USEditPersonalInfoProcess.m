//
//  USEditPersonalInfoProcess.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/27.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USEditPersonalInfoProcess.h"

@implementation USEditPersonalInfoProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:@"107"] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        int code = [response[@"data"][@"code"] intValue];
        if (code == 200) {
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
            NSError *error = [[NSError alloc] init];
            failure(error);
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}
@end
