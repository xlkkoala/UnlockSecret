//
//  USMLookingForDifferentProcess.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/6.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMLookingForDifferentProcess.h"
#import "USMLookingDiffModel.h"

@implementation USMLookingForDifferentProcess
- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:@"119"] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        int code = [response[@"data"][@"code"] intValue];
        if (code == 200) {
           
             USMLookingDiffModel *model = [USMLookingDiffModel mj_objectWithKeyValues:response[@"data"][@"data"]];
            success(model);
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}
@end
