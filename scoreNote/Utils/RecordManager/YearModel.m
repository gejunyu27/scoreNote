//
//  YearModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/8.
//

#import "YearModel.h"

@implementation YearModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _monthModels = [NSMutableArray array];
    }
    return self;
}

- (CGFloat)allProfit
{
    if (_allProfit == 0) { //0的情况很少
        for (MonthModel *month in _monthModels) {
            _allProfit += month.allProfit;
        }
    }
    
    return _allProfit;
}

@end
