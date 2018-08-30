//
//  HttpRequest.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/22.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "HttpRequest.h"


@implementation HttpRequest

- (void)getMessageHandleWithSuccessBlock:(success)success errorBlock:(error)failure{
    NSLog(@"实现子类的方法");
}

- (NSDictionary *)encrypt:(NSString*)data queryid:(NSString *)queryid{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    if (data) {
        [newDic setValue:[self encrypt:data]?[self encrypt:data]:@"" forKey:@"data"];
    }
    if (queryid) {
        [newDic setValue:queryid forKey:@"queryid"];
    }
    if (US_VERSION) {
        [newDic setValue:US_VERSION forKey:@"appVersion"];
    }
    if ([Device currentDevice]) {
        [newDic setValue:[Device currentDevice] forKey:@"device"];
    }
    
    return (NSDictionary *)newDic;
}

- (NSString *)encrypt:(NSString *)plainText{
    
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    //密钥
    Byte keyByte[] = {0x01,0x01,0x04,0x0b,0x02,0x0f,0x0b,0x0c,0x01,0x03,0x09,0x07,0x0c,0x03,
        0x07,0x0a,0x04,0x0f,0x06,0x0f,0x0e,0x09,0x05,0x01,0x0a,0x0a,0x01,0x09,
        0x06,0x07,0x09,0x0d};
    
    //byte转换为NSData类型，以便下边加密方法的调用
    NSData *keyData = [[NSData alloc] initWithBytes:keyByte length:32];
    //
    NSData *cipherTextData = [plainTextData AES256EncryptWithKey:keyData];
    Byte *plainTextByte = (Byte *)[cipherTextData bytes];
    
    
    NSString *hexStr=@"";
    for(int i=0;i<[cipherTextData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",plainTextByte[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return hexStr;
}

@end
