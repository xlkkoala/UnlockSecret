//
//  XLKTool.h
//  SaveData
//
//  Created by FYTech on 16/9/5.
//  Copyright © 2016年 FYTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "USUser.h"
typedef void (^DisMissBlock)(BOOL seccess);
@interface XLKTool : NSObject

#pragma mark 存储数据

+ (BOOL)saveDataByPath:(id)data path:(NSString *)path;

+ (id)currentDataByPath:(NSString *)path;

+ (NSString *)getPathWithComponent:(NSString *)path;

#pragma mark 复制信息到剪切板

+ (BOOL)copyMessageToPastBoard:(NSString *)message;

#pragma mark 指纹验证;
+ (void)evaluateAuthenticate:(DisMissBlock)block;


#pragma mark - 验证输入合格

//匹配邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

//匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

#pragma mark - LoadingView
+ (void)startLoadingWithView:(UIView *)view;

+ (void)endLoadingWithView:(UIView *)view;

#pragma mark -返回拼音首字母
+ (NSString *)firstCharactor:(NSString *)aString;

#pragma mark -冒泡排序
+ (NSMutableArray *)setBubbleSortBySourcesArray:(NSMutableArray *)sourcesArray;

+ (NSString *)changeToCurrentTimeByStamp:(NSNumber *)stamp;
@end
