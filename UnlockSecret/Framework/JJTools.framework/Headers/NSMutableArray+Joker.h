//
//  NSMutableArray+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSMutableArray 扩展方法
 */
@interface NSMutableArray (Joker)

/**
 *  获取对象
 *
 *  @param index 下标索引
 *
 *  @return 当超出范围时返回nil
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 *  移动object索引位置
 *
 *  @param from 开始位置下标
 *  @param to   移动位置下标
 */
- (void)moveObjectFromIndex:(NSUInteger)from
                    toIndex:(NSUInteger)to;

/**
 *  将数组对象倒叙
 *
 *  @return Return the reversed array
 */
- (NSMutableArray *)reversedArray;

/**
 *  对数组进行排序
 *
 *  @param key       The key to order the array
 *  @param array     The array to be ordered
 *  @param ascending A BOOL to choose if ascending or descending
 *
 *  @return Return the given array ordered by the given key ascending or descending
 */
+ (NSMutableArray *)sortArrayByKey:(NSString *)key
                             array:(NSMutableArray *)array
                         ascending:(BOOL)ascending;

@end




