//
//  TotalSectionModel.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/31.
//

#import "TotalSectionModel.h"

@implementation TotalSectionModel
- (NSMutableArray<RecordModel *> *)recordList
{
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}

@end
