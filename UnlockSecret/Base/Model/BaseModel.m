//
//  BaseModel.m
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.dictionary = [self checkValueSafe:dictionary];
    if (self.dictionary) {
        return self;
    }
    return nil;
}

- (id)valueForKey:(NSString *)key type:(Class)type{
    if ([self.dictionary[key] isKindOfClass:type]) {
        return self.dictionary[key];
    }
    if (type == [NSNumber class]) {
        return @0;
    }
    if (type == [NSString class]) {
        return @"";
    }
    return nil;
}

- (NSDictionary *)checkValueSafe:(NSDictionary *)dictionary{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]] || dictionary.count == 0) {
        return nil;
    }
    return dictionary;
}

@end
