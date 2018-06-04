//
//  NSData+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Joker)

/**
 *  AES256加密
 *
 *  @param key 密钥
 *
 *  @return 加密后Data
 */
- (NSData *)AES256EncryptWithKey:(NSData *)key;

/**
 *  AES256解密
 *
 *  @param key 密钥
 *
 *  @return 解密后Data
 */
- (NSData *)AES256DecryptWithKey:(NSData *)key;

@end
