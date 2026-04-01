//
//  TotalSectionModel.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/31.
//

#import "TotalSectionModel.h"

@interface TotalSectionModel ()
@property (nonatomic, strong) NSMutableArray <RecordModel *> *mutableList;
@end

@implementation TotalSectionModel
- (NSArray<RecordModel *> *)recordList
{
    return self.mutableList.copy;
}

- (NSMutableArray<RecordModel *> *)mutableList
{
    if (!_mutableList) {
        _mutableList = [NSMutableArray array];
    }
    return _mutableList;
}

//单子操作
- (void)addRecord:(RecordModel *)record
{
    if (record) {
        [self.mutableList addObject:record];
        
        _allOut += record.allOut;
        _allGet += record.allGet;
        _allProfit += record.allProfit;
    }
}


@end
