//
//  RecordModel.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/29.
//

#import "RecordModel.h"
#import "TagManager.h"

@interface RecordModel ()
@property (nonatomic, strong) NSMutableArray *mutableList;
@end

@implementation RecordModel

- (NSArray<LineModel *> *)lineList
{
    return self.mutableList.copy;
}

- (void)setIsOver:(BOOL)isOver
{
    if (isOver && !_isOver) {
        _endTime = [NSDate date];
        _overTagName = _tagModel.name;
    }
    
    _isOver = isOver;
}

- (void)setTagId:(NSInteger)tagId
{
    _tagId = tagId;
    
    _tagModel = [TagManager getTag:tagId];
}




- (NSMutableArray *)mutableList
{
    if (!_mutableList) {
        _mutableList = [NSMutableArray array];
    }
    return _mutableList;
}


//列表操作
- (void)addLine:(LineModel *)line
{
    if (line && line.class == LineModel.class) {
        [self.mutableList addObject:line];
    }
    
    [self refreshData];

}

- (void)deleteLine:(LineModel *)line
{
    if (line && [self.mutableList containsObject:line]) {
        [self.mutableList removeObject:line];
    }
    
    [self refreshData];
}

- (void)addLines:(NSArray <LineModel *> *)lines
{
    if (lines.count > 0) {
        [self.mutableList addObjectsFromArray:lines];
    }
    
    [self refreshData];
}

- (void)refreshData
{
    //总支出
    _allOut = 0;
    //总收入
    _allGet = 0;
    for (LineModel *line in self.mutableList) {
        _allGet += line.getMoney;
        _allOut += line.outMoney;
    }
    
    //总利润
    _allProfit = _allGet - _allOut;
    
    //开始时间
    if (self.mutableList.count > 0) {
        LineModel *firstLine = self.mutableList.firstObject;
        _startTime = firstLine.beginTime;
    }
    
    //是否止损中
    _isBreaking = _allProfit <= -_breakLine;
}

@end

