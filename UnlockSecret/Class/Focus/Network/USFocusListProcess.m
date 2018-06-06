//
//  USFocusListProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/24.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USFocusListProcess.h"

@implementation USFocusListProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_FOCUS_LIST] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        NSMutableArray *focusArray = [NSMutableArray array];
        if ([response[@"data"][@"success"] isEqual:@1]) {
            NSMutableArray *dataArray = response[@"data"][@"data"];
            for (int i = 0; i < dataArray.count; i ++) {
                USUser *user = [[USUser alloc] initWithDictionary:dataArray[i]];
                [focusArray addObject:user];
            }
            success(focusArray);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}


@end
