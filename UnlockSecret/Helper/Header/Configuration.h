//
//  Configuration.h
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#ifndef Configuration_h
#define Configuration_h

 /*
 // 字体颜色
 */
#define NAV_COLOR [UIColor whiteColor]  //导航字体颜色
#define NAV_BACKGROUNDCOLOR ColorFromRGB(43, 50, 92)// 导航栏背景颜色
#define TABBAR_BACKGROUNDCOLOR ColorFromRGB(62, 37, 99)// tabbar背景颜色
#define gray90 [UIColor colorWithHexString:@"e5e5e5"]   //分割线

 /*
 // 字体大小
 */
#define NAV_FONT [UIFont systemFontOfSize:20]  //导航字体大小


 /*
 // 本地单例
 */
#define UERR_DEFAULTS   [NSUserDefualts standarUserDefualts]

 /*
 // 版本号
 */
#define US_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

 /*
 // storyboard
 */

#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define FOCUS_STORYBOARD [UIStoryboard storyboardWithName:@"Focus" bundle:nil]
#define RELEASE_STORYBOARD [UIStoryboard storyboardWithName:@"Release" bundle:nil]
#define MESSAGE_STORYBOARD [UIStoryboard storyboardWithName:@"Message" bundle:nil]
#define USER_STORYBOARD [UIStoryboard storyboardWithName:@"User" bundle:nil]
#define LOGIN_STORYBOARD [UIStoryboard storyboardWithName:@"Login" bundle:nil]
#define CHAT_STORYBOARD [UIStoryboard storyboardWithName:@"Chat" bundle:nil]

 /*
 // 是否为iphone x
 */

#define _IPHONE_X [[Device currentDevice] containsString:@"iPhone X"]

 /*
 // 用户ID
 */

#define USER_ID         [NSString stringWithFormat:@"%@",[LoginHelper currentUser].userid]
//#define USER_ID @"2"

#define DEFUALT_HEADER_IMAGE [UIImage imageNamed:@"morentouxiang"]

 /*
 //  UserDefaults
 */

#define USER_DEFAULT    [NSUserDefaults standardUserDefaults]

 /*
 // 是否第一次打开app
 */

#define isFirstOpen     [USER_DEFUALT objectForKey:@"isFirstOpen"]

// -----默认图片
// 头像默认图
#define DEFAULT_IMAGE_HEADER ImageNamed(@"icon_defult_header")


#endif /* Configuration_h */
