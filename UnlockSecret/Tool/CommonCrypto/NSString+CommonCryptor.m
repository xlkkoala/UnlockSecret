//
//  NSString+CommonCryptor.m
//  lxtxAppCustomer
//
//  Created by com.chetuba on 15/11/10.
//  Copyright © 2015年 LXTX. All rights reserved.
//

#import "NSString+CommonCryptor.h"

#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"

#define KEY @"12345678901234567890123456789012"

@implementation NSString (CommonCryptor)

#pragma ================================GUID========================


+ (NSString *)getUniqueStrByUUID
{
//    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
//    CFRelease(uuid_ref);
//    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
//    NSString *uuid = [NSString stringWithString:(NSString *)CFBridgingRelease(uuid_string_ref)];
//    CFRelease(uuid_string_ref);
//    return uuidString;
    
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
    
    
}


#pragma ================================加密========================
- (NSString *)md5XLTX{
    
    
    
    NSString *l = [self MD5];
    
    NSString *x = [[NSString stringWithFormat:@"%@lxtx",l] MD5];
    
    
    return x;
    
}


- (NSString *)md5Encrypt{
    
    NSString *l = [self MD5];
    
    NSString *x = [[NSString stringWithFormat:@"%@lxtx",l] MD5];
    
    NSString *t = [NSString stringWithFormat:@"%@%@",x,KEY];
    
    return [t MD5];
}

- (NSString *)md5Pojie{
    
    
    NSString *t = [NSString stringWithFormat:@"%@%@",self,KEY];
    
    return [t MD5];
}

- (NSString *)MD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}



+ (NSString *)encrypt:(NSString *)message password:(NSString *)password {
    
    //[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash]
    //NSError * error = nil;
    
    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[password dataUsingEncoding:NSUTF8StringEncoding]  error:nil];
    
    NSLog(@"---error------->%@",[[NSString alloc]initWithData:encryptedData encoding:NSUTF8StringEncoding]);
    
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    
    //NSLog(@"error%@",error);
    
    return base64EncodedString;
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password {
    
    //[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash]
    //NSError * error = nil;
    
    NSData *encryptedData = [NSData base64DataFromString:base64EncodedString];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[password dataUsingEncoding:NSUTF8StringEncoding]  error:nil];
    
    //NSLog(@"error%@",error);
    
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

@end
