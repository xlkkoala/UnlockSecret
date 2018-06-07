//
//  USFocusListProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/24.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USFocusListProcess.h"
#import "USFocusListModel.h"

@implementation USFocusListProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_FOCUS_LIST] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        NSInteger code = [response[@"data"][@"code"] integerValue];
        
        if ( code == 200 ) {
            NSArray *arrtModel = [USFocusListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:arrtModel];
            success(dataArray);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}


@end
