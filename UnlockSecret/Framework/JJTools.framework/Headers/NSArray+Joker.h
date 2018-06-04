//
//  NSArray+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Joker)

/**
 *  获取对象,当超出范围时返回nil
 *
 *  @param index 下标索引
 *
 *  @return 当超出范围时返回nil
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 *  倒叙排列
 *
 *  @return NSArray:倒叙后的数组
 */
- (NSArray *)reversedArray;

@end
