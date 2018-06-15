//
//  USCommentListProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/14.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USCommentListProcess.h"
#import "USCommentListModel.h"
@implementation USCommentListProcess

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    
    [YQNetworking postWithUrl:HOST refreshRequest:NO cache:NO params:[self encrypt:[NSString jsonStringWithDictionary:self.dictionary] queryid:US_COMMENT_LIST] progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        //处理数据
        NSLog(@"%@",response);
        int code = [response[@"data"][@"code"] intValue];
        if (code == 200) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[USCommentListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]]];
            success(dataArray);
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"msg"]];
        }
    } failBlock:^(NSError *error) {
        failure(error);
    }];
}

@end
