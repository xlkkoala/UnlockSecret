//
//  USUploadImageProcess.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/25.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USUploadImageProcess.h"
#import "AFNetworking.h"
@implementation USUploadImageProcess

- (void)uploadImageBySource:(UIImage *)image withProcess:(progress)process wtihSuccess:(success)success withError:(error)error{
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSDictionary *paramter = [self encrypt:[NSString jsonStringWithDictionary:@{@"crpno":@"xunmi",@"userId":@"1"}] queryid:US_UPLOAD_PICTURE];
    NSURLSessionConfiguration *sessionConfiguration;
    sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求headers
    sessionConfiguration.HTTPAdditionalHeaders = @{@"source":@"ios",
                                                   @"type":@"in_house",
                                                   @"language":@"cn"};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HOST] sessionConfiguration:sessionConfiguration];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/plan",
                                                         @"text/html", nil];
    [manager POST:HOST parameters:paramter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData  appendPartWithFileData:data name:@"filedata" fileName:@"currentImage.png" mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"`````````%@",responseObject);
        if ([responseObject[@"data"][@"code"] isEqual:@200]){
//            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            success(responseObject[@"data"][@"url"]);
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
    
}

@end
