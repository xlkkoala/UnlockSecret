//
//  USUploadImageProcess.h
//  UnlockSecret
//
//  Created by xlk on 2018/4/25.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "HttpRequest.h"

@interface USUploadImageProcess : HttpRequest

- (void)uploadImageBySource:(UIImage *)image withProcess:(progress)process wtihSuccess:(success)success withError:(error)error;

@end
