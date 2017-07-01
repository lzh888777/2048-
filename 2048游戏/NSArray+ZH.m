//
//  NSArray+ZH.m
//  2048游戏
//
//  Created by 刘志华 on 14-9-7.
//  Copyright (c) 2014年 刘志华. All rights reserved.
//

#import "NSArray+ZH.h"

@implementation NSArray (ZH)

+ (instancetype)arrayWithOtherArray:(NSArray *)array{
    
    NSMutableArray  * arrayM = [NSMutableArray arrayWithCapacity:array.count];
    for (id obj in array) {
        [arrayM addObject:obj];
    }
    
    NSArray *instance = arrayM ;
    return instance;
}

@end
