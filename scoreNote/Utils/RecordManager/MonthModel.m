//
//  MonthModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/8.
//

#import "MonthModel.h"

@implementation MonthModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _records = [NSMutableArray array];
    }
    return self;
}

- (CGFloat)allProfit
{
    if (_allProfit == 0) { //0的情况很少
        for (RecordModel *record in _records) {
            _allProfit += record.allProfit;
        }
    }
    
    return _allProfit;
}

@end
