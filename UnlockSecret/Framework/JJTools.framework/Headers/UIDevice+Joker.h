//
//  UIDevice+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Joker)

/**
 *  比较系统版本号
 *
 *  @param v Version, like @"8.0"
 *
 *  @return Return a BOOL
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 *  Return the device platform string
 *  Example: "iPhone3,2"
 *
 *  @return Return the device platform string
 */
+ (NSString *)devicePlatform;

/**
 *  Return the user-friendly device platform string
 *  Example: "iPad Air (Cellular)"
 *
 *  @return Return the user-friendly device platform string
 */
+ (NSString *)devicePlatformString;

/**
 *  判断当前设备是不是iPad
 *
 *  @return Return YES if it's an iPad, NO if not
 */
+ (BOOL)isiPad;

/**
 *  判断当前设备是不是iPhone
 *
 *  @return Return YES if it's an iPhone, NO if not
 */
+ (BOOL)isiPhone;

/**
 *  判断当前设备是不是iPod
 *
 *  @return Return YES if it's an iPod, NO if not
 */
+ (BOOL)isiPod;

/**
 *  判断当前设备是不是模拟器
 *
 *  @return Return YES if it's the simulator, NO if not
 */
+ (BOOL)isSimulator;

/**
 *  判断当前设备是不是 Retina 屏
 *
 *  @return Return YES if it has a Retina display, NO if not
 */
+ (BOOL)isRetina;

/**
 *  判断当前设备是不是 Retina HD 屏
 *
 *  @return Return YES if it has a Retina HD display, NO if not
 */
+ (BOOL)isRetinaHD;

/**
 * 获取当前系统版本号
 *
 *  @return Return the iOS version
 */
+ (float)iOSVersion;

/**
 *  获取当前设备CUP频率
 *
 *  @return Return the current device CPU frequency
 */
+ (NSUInteger)cpuFrequency;

/**
 *  Return the current device BUS frequency
 *
 *  @return Return the current device BUS frequency
 */
+ (NSUInteger)busFrequency;

/**
 *  获取设备内存大小
 *
 *  @return Return the current device RAM size
 */
+ (NSUInteger)ramSize;

/**
 *  获取设备CUP数量
 *
 *  @return Return the current device CPU number
 */
+ (NSUInteger)cpuNumber;

/**
 *  设备总的内存
 *
 *  @return Return the current device total memory
 */
+ (NSUInteger)totalMemory;

/**
 *  当前设备非内核内存
 *
 *  @return Return the current device non-kernel memory
 */
+ (NSUInteger)userMemory;

/**
 *  当前设备总磁盘空间
 *
 *  @return Return the current device total disk space
 */
+ (NSNumber *)totalDiskSpace;

/**
 *  当前设备空闲磁盘空间
 *
 *  @return Return the current device free disk space
 */
+ (NSNumber *)freeDiskSpace;

/**
 *  当前设备的MAC地址
 *
 *  @return Return the current device MAC address
 */
+ (NSString *)macAddress;

/**
 *  生成一个惟一的标识符并存储到standardUserDefaults
 *
 *  @return Return a unique identifier as a NSString
 */
+ (NSString *)uniqueIdentifier;

@end
