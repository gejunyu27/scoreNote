//
//  LineModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import "LineModel.h"

@implementation LineModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _beginTime = [NSDate date];
    }
    return self;
}

- (void)setIsOver:(BOOL)isOver
{
    if (isOver && !_isOver) {
        _endTime = [NSDate date];
        
        if (self == self.record.lineList.lastObject) { //如果是最后一个，结束的时候保留当前买法
            self.overScore = self.record.currentScore;
        }
    }
    
    _isOver = isOver;
}

@end
