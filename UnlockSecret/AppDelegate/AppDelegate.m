//
//  AppDelegate.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <JMessage/JMessage.h>

#import "JSHAREService.h"
#import "USChatListViewController.h"
#import "BaseNavigationController.h"
#import <SMS_SDK/SMSSDK.h>

static NSString *const APPKEY = @"9d967d1bd7f4d1aeb96b20f3";
static NSString *const CHANNEL = @"App Store";


@interface AppDelegate ()<JPUSHRegisterDelegate,UINavigationControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"SMSSDK_VERSION-----%@",[SMSSDK sdkVersion]);
    
    ((UINavigationController * )self.window.rootViewController).delegate = self;
    [JMessage setupJMessage:launchOptions appKey:APPKEY channel:CHANNEL apsForProduction:NO category:nil messageRoaming:NO];
    // 注册通知
    [self begainPushNotification:launchOptions];
    // 注册第三方登录
    [self setJShareCongigWithQQAndWeChat];
    
    return YES;
}

- (void)begainPushNotification:(NSDictionary *)launchOptions{
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:APPKEY
                          channel:CHANNEL
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            [SVProgressHUD showInfoWithStatus:@"1"];
        }
        [SVProgressHUD showInfoWithStatus:@"2"];
    } else {
        // Fallback on earlier versions
        [SVProgressHUD showInfoWithStatus:@"3"];
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            [SVProgressHUD showInfoWithStatus:@"4"];
        }
        [SVProgressHUD showInfoWithStatus:@"5"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"6"];
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required, iOS 7 Support
    if ([[userInfo objectForKey:@"_j_type"] isEqualToString:@"jmessage"]) {
        [SVProgressHUD showInfoWithStatus:@"push"];
        USChatListViewController *vc = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"CHAT_LIST_ID"];
        [self.currentViewController.navigationController pushViewController:vc animated:YES];
    }
    NSLog(@"%@",[userInfo objectForKey:@"_j_type"]);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.currentViewController = viewController;
    if ([navigationController isMemberOfClass:[BaseNavigationController class]]) {
        BaseNavigationController *nvc = (BaseNavigationController *)navigationController;
        if (nvc.viewControllers.count == 1) {
            nvc.currentVirewController = nil;
        } else {
            nvc.currentVirewController = viewController;
        }
    }
}

- (void)setJShareCongigWithQQAndWeChat{
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = @"9d967d1bd7f4d1aeb96b20f3";
    config.QQAppId = @"1106783116";
    config.QQAppKey = @"eh2Rc69ZOrqLf2sD";
    config.WeChatAppId = @"wxd056d3f4007770c7";
    config.WeChatAppSecret = @"1cceaa2ccd1f34ab8b4c620b470fb297";
    [JSHAREService setupWithConfig:config];
    //    [JSHAREService setDebug:YES];
}

//目前适用所有 iOS 系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [JSHAREService handleOpenUrl:url];
    return YES;
}

//仅支持 iOS9 以上系统，iOS8 及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [JSHAREService handleOpenUrl:url];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
