//
//  JJKeychain.h
//  Keychain_Joker
//
//  Created by pengshuai on 15/5/14.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  keychain服务提供了一种安全的保存私密信息,
 *  保证程序在卸载后重新安装数据依然存在
 */
@interface JJKeychain : NSObject

/**
 *  更新服务数据(保存/更新)
 *
 *  @param serviceKey 服务Key
 *  @param value      服务值
 */
+(void)updateServiceKey:(NSString*)serviceKey value:(id)value;
/**
 *  通过服务Key获取服务value
 *
 *  @param serviceKey 服务Key
 */
+(id)valueWithServiceKey:(NSString*)serviceKey;
/**
 *  通过服务Key删除服务value
 *
 *  @param serviceKey 服务Key
 */
+(void)deleteWithServiceKey:(NSString*)serviceKey;

@end
