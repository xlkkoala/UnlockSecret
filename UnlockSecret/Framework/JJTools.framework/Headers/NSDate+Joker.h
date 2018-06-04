//
//  NSDate+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Joker)


/**
*  Date转换为格式化字符串
*
*  @param format 时间格式
*
*  @return NSString:格式化字符串
*/
-(NSString*)toStringWithFormat:(NSString*)format;

/**
 *  获取当前时间字符串
 *
 *  @param format 时间格式
 *
 *  @return NSString:当前时间字符串
 */
+(NSString*)stringWithCurrentTimeFormat:(NSString*)format;



+(NSString*)stringWithCurrentTimeInterval1970_13;

/**
 *  获取当前时间的时间戳字符串10位
 *
 *  @return NSString:时间戳字符串
 */
+(NSString*)stringWithCurrentTimeInterval1970_10;

/**
 *  dateString转换为NSDate类型
 *
 *  @param format     @param format 时间格式
 *  @param dateString @param dateString 时间字符串
 *
 *  @return NSDate
 */
+(NSDate*)dateWithFormat:(NSString*)format dateString:(NSString*)dateString;

/**
 *  将时间戳字符串转换为时间格式字符串
 *
 *  @param format    时间格式
 *  @param timestamp timestamp
 *
 *  @return 字符串NSString
 */
+(NSString*)dateStringWithFormat:(NSString*)format timestamp:(NSString*)timestamp;

/**
 *  将时间戳字符串转换为Date
 *
 *  @param timestamp 时间戳字符串
 *
 *  @return NSDate
 */
+(NSDate*)dateForTimestamp:(NSString*)timestamp;

@end











