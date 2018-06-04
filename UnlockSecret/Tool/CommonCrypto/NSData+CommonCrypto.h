/*
 *  NSData+CommonCrypto.h
 *  AQToolkit
 *
 *  Created by Jim Dovey on 31/8/2008.
 *
 *  Copyright (c) 2008-2009, Jim Dovey
 *  All rights reserved.
 *  
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *  
 *  Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *  
 *  Neither the name of this project's author nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

extern NSString * const kCommonCryptoErrorDomain;

@interface NSError (CommonCryptoErrorDomain)
+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;
@end

@interface NSData (CommonDigest)

- (NSData *) MD2Sum;
- (NSData *) MD4Sum;
- (NSData *) MD5Sum;

- (NSData *) SHA1Hash;
- (NSData *) SHA224Hash;
- (NSData *) SHA256Hash;
- (NSData *) SHA384Hash;
- (NSData *) SHA512Hash;

@end

@interface NSData (CommonCryptor)

- (NSData *) AES256EncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) decryptedAES256DataUsingKey: (id) key error: (NSError **) error;


@end

@interface NSData (LowLevelCommonCryptor)


/**
 *  加密  默认向量为空
 *
 *  @param algorithm 加密类型
 *  @param mode      加密模式
 *  @param padding   填充模式
 *  @param key       钥匙
 *  @param error     错误反馈
 *
 *  @return 密文
 */
- (NSData *) dataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                    mode:(CCMode) mode
                                 padding:(CCPadding) padding
                                     key: (id) key
                                   error: (CCCryptorStatus *) error;

/**
 *  加密
 *
 *  @param algorithm 加密类型
 *  @param mode      加密模式
 *  @param padding   填充模式
 *  @param key       钥匙
 *  @param iv        向量
 *  @param error     错误反馈
 *
 *  @return 密文
 */
- (NSData *) dataEncryptedUsingAlgorithm:(CCAlgorithm) algorithm
                                    mode:(CCMode) mode
                                 padding:(CCPadding) padding
                                     key: (id) key
                    initializationVector: (id) iv
                                   error: (CCCryptorStatus *) error;



/**
 *  解密  默认向量为空
 *
 *  @param algorithm 加密类型
 *  @param mode      加密模式
 *  @param padding   填充模式
 *  @param key       钥匙
 *  @param error     错误反馈
 *
 *  @return 解密后的文字
 */
- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                    mode:(CCMode) mode
                                 padding:(CCPadding) padding
                                     key: (id) key		// data or string
                                   error: (CCCryptorStatus *) error;

/**
 *  解密
 *
 *  @param algorithm 加密类型
 *  @param mode      加密模式
 *  @param padding   填充模式
 *  @param key       钥匙
 *  @param iv        向量
 *  @param error     错误反馈
 *
 *  @return 解密后的文字
 */
- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                    mode:(CCMode)mode
                                 padding:(CCPadding)padding
                                     key: (id) key		// data or string
                    initializationVector: (id) iv		// data or string
                                   error: (CCCryptorStatus *) error;

@end

@interface NSData (CommonHMAC)

- (NSData *) HMACWithAlgorithm: (CCHmacAlgorithm) algorithm;
- (NSData *) HMACWithAlgorithm: (CCHmacAlgorithm) algorithm key: (id) key;

@end