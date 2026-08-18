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

- (void)updateData
{
    _allGet = 0;
    _allOut = 0;
    
    for (RecordModel *record in _records) {
        _allGet += record.allGet;
        _allOut += record.allOut;
    }
    
    _allProfit = _allGet - _allOut;
}

@end
