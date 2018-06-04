//
//  BaseModel.h
//  UnlockSecret
//
//  Created by xlk on 2018/3/20.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, strong)NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)valueForKey:(NSString *)key type:(id)type;

@end
