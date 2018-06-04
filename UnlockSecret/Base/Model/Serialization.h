//
//  Serialization.h
//  UnlockSecret
//
//  Created by xlk on 2018/4/13.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#ifndef Serialization_h
#define Serialization_h

#import <objc/runtime.h>

#define SERIALIZATION()\
\
    SERIALIZATION_ADECODER();\
    SERIALIZATION_ACODER();\
    SERIALIZATION_COPY_WITH_ZONE();\


#define SERIALIZATION_ADECODER()\
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder{\
    NSLog(@"%s",__func__);\
    Class cls = [self class];\
    while (cls != [NSObject class]) {\
        /*判断是自身类还是父类*/\
        BOOL bIsSelfClass = (cls == [self class]);\
        unsigned int iVarCount = 0;\
        unsigned int propVarCount = 0;\
        unsigned int sharedVarCount = 0;\
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/\
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/\
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;\
        \
        for (int i = 0; i < sharedVarCount; i++) {\
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));\
            NSString *key = [NSString stringWithUTF8String:varName];\
            id varValue = [aDecoder decodeObjectForKey:key];\
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];\
            if (varValue && [filters containsObject:key] == NO) {\
                [self setValue:varValue forKey:key];\
            }\
        }\
        free(ivarList);\
        free(propList);\
        cls = class_getSuperclass(cls);\
    }\
    return self;\
}\

#define SERIALIZATION_ACODER()\
\
- (void)encodeWithCoder:(NSCoder *)aCoder{\
    NSLog(@"%s",__func__);\
    Class cls = [self class];\
    while (cls != [NSObject class]) {\
        /*判断是自身类还是父类*/\
        BOOL bIsSelfClass = (cls == [self class]);\
        unsigned int iVarCount = 0;\
        unsigned int propVarCount = 0;\
        unsigned int sharedVarCount = 0;\
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/\
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/\
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;\
    \
        for (int i = 0; i < sharedVarCount; i++) {\
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));\
            NSString *key = [NSString stringWithUTF8String:varName];\
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/\
            id varValue = [self valueForKey:key];\
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];\
            if (varValue && [filters containsObject:key] == NO) {\
                [aCoder encodeObject:varValue forKey:key];\
            }\
    }\
    free(ivarList);\
    free(propList);\
    cls = class_getSuperclass(cls);\
    }\
}

#define SERIALIZATION_COPY_WITH_ZONE()  \
\
/*如果不实现copyWithZone:方法，则[personObject copy]时会崩溃*/   \
- (id)copyWithZone:(NSZone *)zone   \
{   \
    NSLog(@"%s",__func__);  \
    id copy = [[[self class] allocWithZone:zone] init];    \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {  \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
    \
    for (int i = 0; i < sharedVarCount; i++) {  \
        const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
        NSString *key = [NSString stringWithUTF8String:varName];    \
        /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
        id varValue = [self valueForKey:key];   \
        NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
        if (varValue && [filters containsObject:key] == NO) { \
            [copy setValue:varValue forKey:key];    \
        }   \
    }   \
    free(ivarList); \
    free(propList); \
    cls = class_getSuperclass(cls); \
    }   \
    return copy;    \
}

#endif /* Serialization_h */
