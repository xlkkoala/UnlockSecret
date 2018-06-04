//
//  NSString+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSString 扩展方法
 */
@interface NSString (Joker)

#pragma mark -
#pragma mark - 加密算法
/**
 *  MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)MD5;
- (NSString *)SHA1;
- (NSString *)SHA256;
- (NSString *)SHA512;

/**
 *  NSDictionary 转化为json string
 *
 *  @param dictionary NSDictionary
 *
 *  @return NSString:转化后的json string
 */
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

/**
 *  NSArray 转化为json string
 *
 *  @param array NSArray
 *
 *  @return NSString:转化后的json string
 */
+(NSString *) jsonStringWithArray:(NSArray *)array;

/**
 *  string 转化为json string
 *
 *  @param string string
 *
 *  @return NSString:转化后的json string
 */
+(NSString *) jsonStringWithString:(NSString *) string;

/**
 *  object 转化为json string
 *
 *  @param object NSArray/NSDictionary
 *
 *  @return NSString:转化后的json string
 */
+(NSString *) jsonStringWithObject:(id) object;

/**
 * 生成唯一字符串
 */
+ (NSString*) uniqueString;

#pragma mark -
#pragma mark - 转换
/**
 * 去掉左右空格
 */
-(NSString*)removeSpace;

/**
 *  编码的url字符串
 */
- (NSString *)urlEncode;

/**
 *  将字符串转换为UTF-8
 *
 *  @param string 需要转化的string
 *
 *  @return NSString:转化后的json string
 */
+ (NSString *)convertToUTF8Entities:(NSString *)string;

#pragma mark -
#pragma mark - 验证

/**
 *  判断字符串是否为空
 *
 *  @param string 需要验证的字符串
 *
 *  @return YES/NO
 */
+ (BOOL)isNull:(NSString*)string;

/**
 *  判断是不是邮箱
 *
 *  @return YES/NO
 */
- (BOOL)isEmail;

/**
 *  判断是不是电话号码
 *
 *  @param phoneNumber 验证的字符串
 *
 *  @return YES/NO
 */
+ (BOOL)isPhoneNumber:(NSString*)phoneNumber;

/**
 *  判断是否为浮点型
 *
 *  @return YES/NO
 */
-(BOOL)isPureFloat;

/**
 * 判断是否为int型
 **/
-(BOOL)isPureInt;
/**
 *  汉字转换为拼音
 *
 *  @return 汉字拼音
 */
- (NSString *)transformToPinyin;

/**
 *  验证邮编
 *
 *  @param value 字符串
 *
 *  @return @return YES/NO
 */
+ (BOOL) isValidZipcode:(NSString*)value;

@end












