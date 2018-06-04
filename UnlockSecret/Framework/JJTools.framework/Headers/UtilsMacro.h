//
//  UtilsMacro.h
//  ProjectTemplate_PS
//
//  Created by pengshuai on 14-5-15.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//

#pragma mark - ===================获取设备大小=====================
//获取屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//获取屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#pragma mark - ===================系统版本========================

//当前设备系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//获取设备当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark - ===================UIImage图片=====================
//读取本地图片
#define LoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:type]]

//定义UIImage对象
#define ImageNamed(imageName) [UIImage imageNamed:imageName]

#pragma mark - ===================错误描述信息===========================

#define ERROR_Description(error) [error.userInfo objectForKey:NSLocalizedDescriptionKey]

#pragma mark - ===================颜色类===========================

//清除背景色
#define CLEARCOLOR [UIColor clearColor]
//RGB的颜色
#define ColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//十六进制
#define ColorFromHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorFromHexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#pragma mark - ===================UserDefaults===========================
//UserDefaults
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


#pragma mark - ===================GCD===========================

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark - ===================打印日志===========================
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"=====> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#ifdef DEBUG
#define D_NSLog(format, ...) NSLog((@"=====> " format), ## __VA_ARGS__)
#else
#define D_NSLog(format, ...)
#endif

#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)
#define DOBJ(obj)  DLOG(@"%s: %@", #obj, [(obj) description])
#define MARK    NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)


#pragma mark - ===================其它===========================
//
#define StringValue(object) [NSString stringWithFormat:@"%@",object]
#define StringFormat(format,...) [NSString stringWithFormat:format, ##__VA_ARGS__]


//由角度获取弧度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
//有弧度获取角度
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

#define Tel(phoneNumber) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]])









