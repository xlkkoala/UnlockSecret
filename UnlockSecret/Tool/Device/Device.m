//
//  Device.m
//  Che-byMall
//
//  Created by ZhangSC on 16/1/22.
//  Copyright © 2016年 FYTech. All rights reserved.
//

#import "Device.h"
#import <sys/utsname.h>

@implementation Device

+ (NSString *)currentDevice {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [self deviceFilter:[NSString stringWithCString:systemInfo.machine
                                                 encoding:NSUTF8StringEncoding]];
}

+ (NSString *)deviceFilter:(NSString *)device{
    if ([device isEqualToString:@"i386"]) return @"32-bit Simulator";
    if ([device isEqualToString:@"x86_64"]) return @"64-bit Simulator";
    
    if ([device isEqualToString:@"iPod1,1"]) return @"iPod Touch";
    if ([device isEqualToString:@"iPod2,1"]) return @"iPod Touch 2";
    if ([device isEqualToString:@"iPod3,1"]) return @"iPod Touch 3";
    if ([device isEqualToString:@"iPod4,1"]) return @"iPod Touch 4";
    if ([device isEqualToString:@"iPod7,1"]) return @"iPod Touch 6";
    
    if ([device isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([device isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([device isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([device isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([device isEqualToString:@"iPad2,5"]) return @"iPad Mini";
    if ([device isEqualToString:@"iPad4,1"]) return @"iPad Air";   //Wifi
    if ([device isEqualToString:@"iPad4,2"]) return @"iPad Air";   //Cellular
    if ([device isEqualToString:@"iPad4,4"]) return @"iPad Mini";  //Mini
    if ([device isEqualToString:@"iPad4,5"]) return @"iPad Mini";  //Cellular
    if ([device isEqualToString:@"iPad4,7"]) return @"iPad Mini";
    
    if ([device isEqualToString:@"iPhone1,1"])  return @"iPhone";
    if ([device isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if ([device isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    if ([device isEqualToString:@"iPhone3,1"])  return @"iPhone 4 (GSM)";
    if ([device isEqualToString:@"iPhone3,3"])  return @"iPhone 4 (CDMA/Verizon/Sprint)";
    if ([device isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    if ([device isEqualToString:@"iPhone5,1"])  return @"iPhone 5";  //(model A1428, AT&T/Canada)
    if ([device isEqualToString:@"iPhone5,2"])  return @"iPhone 5";   //(model A1429, everything else)
    if ([device isEqualToString:@"iPhone5,3"])  return @"iPhone 5C";   //(model A1456, A1532 | GSM)
    if ([device isEqualToString:@"iPhone5,4"])  return @"iPhone 5C";   //(model A1507, A1516, A1526 (China), A1529 | Global)
    if ([device isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    if ([device isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";   //(model A1457, A1518, A1528 (China), A1530 | Global)
    if ([device isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    if ([device isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    if ([device isEqualToString:@"iPhone8,1"])  return @"iPhone 6S";
    if ([device isEqualToString:@"iPhone8,2"])  return @"iPhone 6S Plus";
    if ([device isEqualToString:@"iPhone9,1"])  return @"国行、日版、港行iPhone 7";
    if ([device isEqualToString:@"iPhone9,2"])  return @"港行、国行iPhone 7 Plus";
    if ([device isEqualToString:@"iPhone9,3"])  return @"美版、台版iPhone 7";
    if ([device isEqualToString:@"iPhone9,4"])  return @"美版、台版iPhone 7 Plus";
    if ([device isEqualToString:@"iPhone10,1"]) return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([device isEqualToString:@"iPhone10,4"]) return @"美版(Global/A1905)iPhone 8";
    if ([device isEqualToString:@"iPhone10,2"]) return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([device isEqualToString:@"iPhone10,5"]) return @"美版(Global/A1897)iPhone 8 Plus";
    if ([device isEqualToString:@"iPhone10,3"]) return @"国行(A1865)、日行(A1902)iPhone X";
    if ([device isEqualToString:@"iPhone10,6"]) return @"美版(Global/A1901)iPhone X";
    return nil;
}


@end
