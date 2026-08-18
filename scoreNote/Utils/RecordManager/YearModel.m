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

- (void)updateData
{
    _allGet = 0;
    _allOut = 0;
    
    for (MonthModel *month in _monthModels) {
        [month updateData];
        _allGet += month.allGet;
        _allOut += month.allOut;
    }
    
    _allProfit = _allGet - _allOut;
}

@end
