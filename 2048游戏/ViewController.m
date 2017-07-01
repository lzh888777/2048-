//
//  ViewController.m
//  2048游戏
//
//  Created by 刘志华 on 14-9-7.
//  Copyright (c) 2014年 刘志华. All rights reserved.
//

#import "ViewController.h"
#import "GameButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *directionBtnsView;
@property (weak, nonatomic) IBOutlet UIView *gameView;
- (IBAction)Up;
- (IBAction)Down;
- (IBAction)Left;
- (IBAction)Right;
@property (weak, nonatomic) IBOutlet UIView *gameOverView;
- (IBAction)restart;

@property (strong,nonatomic) NSMutableArray *numBtns;

@property (strong,nonatomic) NSArray *bgBtns;

@end

@implementation ViewController

- (IBAction)Up {
    
    [self moveToDown:NO fromLeft:NO];
}

- (IBAction)Down {

    [self moveToDown:YES fromLeft:NO];
}

- (void)moveToDown:(BOOL)isDown fromLeft:(BOOL)formLeft{
    
    if (formLeft) {
        [self.numBtns makeObjectsPerformSelector:@selector(exchangeCoordinateXY)];
    }
    
    [self lockAllButtonClick];
    int moveCount = 0;
    int Move = isDown ? kStep - 1 : 0;
    int flag = isDown ? 1 : -1;
    for (int i = 0; i < kStep; i ++) {
        NSMutableArray *array = [NSMutableArray array];
        for (GameButton *button  in self.numBtns) {
            if (button.coordinate.x == i) {
                [array addObject:button];
            }
        }
        
        if (array.count == 1) {
            GameButton *button = array[0];
            moveCount += [self btnBeginAnimation:button withCoordinate:(Coordinate){button.coordinate.x,Move} completion:nil formLeft:formLeft];
        }else if(array.count > 1){
            [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                int x1 = [(GameButton *)obj1 coordinate].y;
                int x2 = [(GameButton *)obj2 coordinate].y;
                if (isDown) {
                    
                    if ((x1 > x2)) {
                        return NSOrderedAscending;
                    }else{
                        return NSOrderedDescending;
                    }
                }else{
                    if ((x1 < x2)) {
                        return NSOrderedAscending;
                    }else{
                        return NSOrderedDescending;
                    }
                }
            }];
                BOOL isCombin = NO;
                for (int j = 0; j < array.count; j ++) {
                    GameButton *button = array[j];
                    if (j == 0) {
                        moveCount += [self btnBeginAnimation:button withCoordinate:(Coordinate){button.coordinate.x,Move} completion:nil formLeft:formLeft];
                    }else{
                        GameButton *Prebutton = array[j - 1];
                        if (button.currentNum == Prebutton.currentNum&&!isCombin) {
                            
                            isCombin = YES;
                            [self.numBtns removeObject:Prebutton];
                            button.currentNum = button.currentNum * 2;
                            moveCount +=[self btnBeginAnimation:button withCoordinate:Prebutton.coordinate completion:^{
                                [button updateBtnTitle];
                                [Prebutton removeFromSuperview];
                            } formLeft:formLeft];
                        }else{
                            if (j + 1 < array.count) {
                                GameButton *nextButton = array[j + 1];
                                if (nextButton.currentNum == button.currentNum) {
                                    isCombin = NO;
                                    
                                }
                            }
                            moveCount += [self btnBeginAnimation:button withCoordinate:(Coordinate){button.coordinate.x ,Prebutton.coordinate.y - 1 * flag} completion:nil formLeft:formLeft];
                        }
                    }
                    
                }
            
        }
    }
    
    if (formLeft) {
        [self.numBtns makeObjectsPerformSelector:@selector(exchangeCoordinateXY)];
    }
    if (moveCount > 0) {
        [self createNewBtn];
    }else{
        [self unLockAllButtonClick];
    }
}


- (IBAction)Left {
    
    [self moveToDown:NO fromLeft:YES];}

- (IBAction)Right {
    [self moveToDown:YES fromLeft:YES];

}

- (int)btnBeginAnimation:(GameButton *)button withCoordinate:(Coordinate)coordinate  completion:(void(^)())completion formLeft:(BOOL)formLeft{
    

    CGFloat margin = button.frame.size.width / (kStep + 1);
    CGFloat btnMoveDistance = button.frame.size.width + margin;
    
    int deltaX = coordinate.x - button.coordinate.x;
    int deltaY = coordinate.y - button.coordinate.y;
    
    if (formLeft) {
        int temp = deltaX;
        deltaX = deltaY;
        deltaY = temp;
    }
    [UIView animateWithDuration:ktime animations:^{
        button.transform = CGAffineTransformTranslate(button.transform, deltaX * btnMoveDistance, deltaY * btnMoveDistance);
    } completion:^(BOOL finished) {
        if (completion) {
            
            completion();
            
        }
        
        
    }];
    button.coordinate = coordinate;
    
    if (deltaX == 0 && deltaY == 0) {
        return 0;
    }else{
        return 1;
    }
}

- (void)lockAllButtonClick{
    self.directionBtnsView.userInteractionEnabled = NO;
}

- (void)unLockAllButtonClick{
    self.directionBtnsView.userInteractionEnabled = YES;
}

- (void)createNewBtn{
    
    BOOL find = NO;
    GameButton *button = nil;
    while (!find) {
        find = YES;
        int random = arc4random_uniform(kStep *kStep);
        button = self.bgBtns[random];
        Coordinate coordinate = button.coordinate;
        for (GameButton *btn  in self.numBtns) {
            Coordinate numCoordinate = btn.coordinate;
            if (numCoordinate.x == coordinate.x && numCoordinate.y == coordinate.y) {
                find = NO;;
            }
        }
    }
    GameButton *numbutton = [[GameButton alloc]initWithFrame:button.frame];
    numbutton.coordinate = button.coordinate;
    numbutton.transform = CGAffineTransformMakeScale(0, 0);
    [self addObjectToView:numbutton];
    [UIView animateWithDuration:ktime animations:^{
        numbutton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (self.numBtns.count == kStep * kStep) {
            if ([self isGameOver]) {
                NSLog(@"Game is over");
                self.gameOverView.hidden = NO;
                return;
            }else{
                [self.numBtns makeObjectsPerformSelector:@selector(exchangeCoordinateXY)];
            }
        }
    }];
    
    if (self.numBtns.count == kStep * kStep) {
        if ([self isGameOver]) {
            NSLog(@"Game is over");
        self.gameOverView.hidden = NO;
            return;
        }else{
            [self.numBtns makeObjectsPerformSelector:@selector(exchangeCoordinateXY)];
        }
    }
    
    [self unLockAllButtonClick];
}

- (BOOL)isGameOver{
    
    BOOL result1 = [self RowOver];
    [self.numBtns makeObjectsPerformSelector:@selector(exchangeCoordinateXY)];
    BOOL result2 = [self RowOver];
    
    return result1 && result2;
}

- (BOOL)RowOver{
    
    for (int i = 0; i < kStep; i ++) {
        NSMutableArray *array = [NSMutableArray array];
        for (GameButton *button  in self.numBtns) {
            if (button.coordinate.y == i) {
                [array addObject:button];
            }
        }
            [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                int x1 = [(GameButton *)obj1 coordinate].x;
                int x2 = [(GameButton *)obj2 coordinate].x;
              
                    if (x1 > x2) {
                        return NSOrderedAscending;
                    }else{
                        return NSOrderedDescending;
                    }
            }];
            for (int j = 0; j < array.count; j ++) {
                GameButton *button = array[j];
                if (j > 0){
                    GameButton *Prebutton = array[j - 1];
                    if (button.currentNum == Prebutton.currentNum) {
                        return NO;
                    }
                }
            }
    }
    return YES;
}

- (IBAction)restart {
    [self.numBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.numBtns removeAllObjects];
    [self setGameStart];
    self.gameOverView.hidden = YES;
    [self unLockAllButtonClick];
}

- (NSMutableArray *)numBtns{
    if (_numBtns == nil) {
        _numBtns = [NSMutableArray array];
    }
    
    return _numBtns;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpBtns];
    
    [self setGameStart];
}

- (void)setGameStart{
    
    int random = arc4random_uniform(kStep * kStep);
    int random1 = arc4random_uniform(kStep * kStep);
    while (random == random1) {
        random1 = arc4random_uniform(kStep * kStep);
    }
    GameButton *button = self.bgBtns[random];
    GameButton *button1= self.bgBtns[random1];
    
    GameButton *numbutton = [[GameButton alloc]initWithFrame:button.frame];
    numbutton.coordinate = button.coordinate;
    GameButton *numbutton1 = [[GameButton alloc]initWithFrame:button1.frame];
    numbutton1.coordinate = button1.coordinate;
    
    [self addObjectToView:numbutton];
    [self addObjectToView:numbutton1];
    
}

- (void)addObjectToView:(GameButton *)button{
    [self.numBtns addObject:button];
    [self.gameView addSubview:button];
    button.show = YES;
}

- (void)setUpBtns{
    
    int numOfBtns = kStep * kStep;
    NSMutableArray *btnsM = [NSMutableArray arrayWithCapacity:numOfBtns];
    CGFloat btnW = self.gameView.frame.size.width / (kStep + 1);
    CGFloat margin = btnW / (kStep + 1);
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < numOfBtns; i ++) {
        
        int row = i / kStep;
        int col = i % kStep;
        btnX = col * (margin + btnW) + margin;
        btnY = row * (margin + btnW) + margin;
        
        GameButton * button = [GameButton buttonWithType:UIButtonTypeCustom];
        [self.gameView addSubview:button];
        [btnsM addObject:button];
        [button setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        
        button.coordinate = (Coordinate){col,row};
        
    }
    self.bgBtns = btnsM;
    
}

//是对方很快很快就好

@end
