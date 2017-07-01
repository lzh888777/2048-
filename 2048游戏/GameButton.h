//
//  GameButton.h
//  2048游戏
//
//  Created by 刘志华 on 14-9-7.
//  Copyright (c) 2014年 刘志华. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStep 4
#define ktime 0.4

struct Coordinate{
    int x;
    int y;
};

typedef struct Coordinate Coordinate;

@interface GameButton : UIButton

@property (assign,nonatomic,getter = isShow)BOOL show;

@property (assign,nonatomic)NSInteger currentNum;

@property (strong,nonatomic)UIColor *textColor;

@property (assign,nonatomic)Coordinate coordinate;

- (void)exchangeCoordinateXY;

- (void)updateBtnTitle;

@end
