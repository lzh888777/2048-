//
//  GameButton.m
//  2048游戏
//
//  Created by 刘志华 on 14-9-7.
//  Copyright (c) 2014年 刘志华. All rights reserved.
//

#import "GameButton.h"
#import "BtnColor.h"



@implementation GameButton

//@synthesize currentNum = _currentNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:40];
        [self setBackgroundColor:[UIColor colorWithRed:0.8 green:0.75 blue:0.7 alpha:1.0]];
        _show = NO;
    }
    return self;
}

- (void)updateBtnTitle{
    
    NSString *text = [NSString stringWithFormat:@"%d",self.currentNum];
    [self setTitle:text forState:UIControlStateNormal];
    BtnColor *color = [[BtnColor alloc]initWithNum:self.currentNum];
    [self setBackgroundColor:color];
    
    if (self.currentNum > 4 ){
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (self.currentNum >=1024) {
            self.titleLabel.font = [UIFont systemFontOfSize:25];
        }else if (self.currentNum >= 128){
            self.titleLabel.font = [UIFont systemFontOfSize:35];
        }
    }
    _currentNum = self.currentNum;
}

- (void)setTextColor:(UIColor *)textColor{
    
    [self setTitleColor:textColor forState:UIControlStateNormal];
}


- (void)setShow:(BOOL)show{
    
    if (_show == NO&&show == YES) {
        int shownum = (arc4random_uniform(2)+ 1) * 2;
        self.currentNum = shownum;
        [self updateBtnTitle];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (show == NO){
        
    }
}

- (void)exchangeCoordinateXY{
    
    self.coordinate = (Coordinate){self.coordinate.y,self.coordinate.x};
}

@end
