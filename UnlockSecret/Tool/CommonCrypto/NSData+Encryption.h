//
//  NSData+Encryption.h
//  jiami
//
//  Created by 程浪V587 on 16/4/21.
//  Copyright © 2016年 black. All rights reserved.
//


//http://my.oschina.net/nicsun/blog/95632?fromerr=PBdUsCtN

#import <Foundation/Foundation.h>

@interface NSData (Encryption)
- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;
+(NSData*)stringToByte:(NSString*)string;
@end
