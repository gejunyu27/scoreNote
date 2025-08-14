//
//  TagRankModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/20.
//

#import "TagRankModel.h"

@implementation TagRankModel

- (NSMutableArray<RecordModel *> *)recordList
{
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}

- (NSString *)name
{
    if (!_name) {
        _name = @"无";
    }
    return _name;
}


@end
