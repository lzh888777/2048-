//
//  BtnColor.m
//  2048游戏
//
//  Created by 刘志华 on 14-9-7.
//  Copyright (c) 2014年 刘志华. All rights reserved.
//

#import "BtnColor.h"
#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface BtnColor ()

@property (strong,nonatomic)NSArray *colorArray;

@end

@implementation BtnColor

- (instancetype)initWithNum:(int)num{
    if ([super init]) {
        if (num == 256) {
            num = 128;
        }
        int index = log2(num) - 1;
        return self.colorArray[index];
    }else{
        return nil;
    }
    
}

- (NSArray *)colorArray{
    if (_colorArray == nil) {
        

        _colorArray = @[Color(238, 228, 218),Color(237, 224, 200),Color(242, 177, 121),Color(245, 149, 99),Color(246, 124, 95),Color(246, 94, 59),Color(237, 207, 114),Color(153, 204, 0),Color(153, 242, 0),Color(153, 242, 0),Color(253, 242, 0)];
    }
    
    return _colorArray;
}

@end
