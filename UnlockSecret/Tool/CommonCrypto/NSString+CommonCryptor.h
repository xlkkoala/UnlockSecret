//
//  NSString+CommonCryptor.h
//  lxtxAppCustomer
//
//  Created by com.chetuba on 15/11/10.
//  Copyright © 2015年 LXTX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommonCryptor)




#pragma ================================GUID========================

+ (NSString *)getUniqueStrByUUID;

#pragma ================================加密========================
- (NSString *)md5XLTX;

/**
 *  次项目的 MD5特殊加密
 *
 *  @return 加密字符
 */
- (NSString *)md5Encrypt;

- (NSString *)MD5;
/**
 *  破解
 *
 *  @return <#return value description#>
 */
- (NSString *)md5Pojie;



/**
 *  AES 128 加密
 *
 *  @param message  信息
 *  @param password 密钥
 *
 *  @return 密文
 */
+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
/**
 *  AES 128 解密
 *
 *  @param base64EncodedString 密文
 *  @param password            密钥
 *
 *  @return 明文
 */
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
