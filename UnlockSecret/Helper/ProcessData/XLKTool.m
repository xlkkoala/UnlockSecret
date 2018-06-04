//
//  XLKTool.m
//  SaveData
//
//  Created by FYTech on 16/9/5.
//  Copyright © 2016年 FYTech. All rights reserved.
//

#import "XLKTool.h"
#import <objc/runtime.h>
#import <LocalAuthentication/LocalAuthentication.h>
#define FIRST_FILEPATH @"XLK"
static NSString * const LoadingViewKey;
@implementation XLKTool

+ (BOOL)saveDataByPath:(id)data path:(NSString *)path{
    return  [NSKeyedArchiver archiveRootObject:data toFile:[self getPathWithComponent:path]];
}

+ (id)currentDataByPath:(NSString *)path{
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPathWithComponent:nil]];
}

+ (NSString *)getPathWithComponent:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *urlStr = [paths objectAtIndex:0];
    urlStr=[urlStr stringByAppendingPathComponent:@"user"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:urlStr]) {
        [manager createDirectoryAtPath:urlStr withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (path.length) {
        urlStr=[urlStr stringByAppendingPathComponent:path];
    } else {
        urlStr=[urlStr stringByAppendingPathComponent:@"user"];
    }
    return urlStr;
}

+ (BOOL)copyMessageToPastBoard:(NSString *)message{
    if (message.length) {
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        [board setString:message];
        return YES;
    }
    return NO;
}

+ (void)evaluateAuthenticate:(DisMissBlock)block
{
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                block(success);
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权，如其他APP切入
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}
#pragma mark - 验证输入合格
//利用正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //多音字将zhang改变为chang
    if ([[(NSString *)aString substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    //    NSLog(@"%@,%@",str,[pinYin substringToIndex:1]);
    return [pinYin substringToIndex:1];
}

//冒泡排序
+ (NSMutableArray *)setBubbleSortBySourcesArray:(NSMutableArray *)sourcesArray{
    int i,j;
    for (i = 0; i < sourcesArray.count; i ++) {
        for (j = (int)sourcesArray.count - 1; j > i; j --) {
            if ([sourcesArray[j] integerValue] > [sourcesArray[j-1] integerValue]) {
                [sourcesArray exchangeObjectAtIndex:j withObjectAtIndex:j-1];
            }
        }
    }
    for (i = 0; i < sourcesArray.count ; i ++) {
        NSLog(@"%@",sourcesArray[i]);
    }
    return sourcesArray;
}

+ (NSString *)changeToCurrentTimeByStamp:(NSNumber *)stamp{
    // timeStampString 是服务器返回的13位时间戳
    NSString *timeStampString  = [NSString stringWithFormat:@"%@",stamp];
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}

@end
