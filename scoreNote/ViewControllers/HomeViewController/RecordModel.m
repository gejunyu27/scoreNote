//
//  RecordModel.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/29.
//

#import "RecordModel.h"
#import "TagManager.h"

@implementation RecordModel

- (CGFloat)allGet
{
    CGFloat num = 0;
    for (LineModel *line in _lineList) {
        num+=line.getMoney;
    }
    return num;
}

- (CGFloat)allOut
{
    CGFloat num = 0;
    for (LineModel *line in _lineList) {
        num+=line.outMoney;
    }
    return num;
}

- (CGFloat)allProfit
{
    CGFloat num = 0;
    for (LineModel *line in _lineList) {
        num+=(line.getMoney - line.outMoney);
    }
    return num;
}

- (NSMutableArray<LineModel *> *)lineList
{
    if (!_lineList) {
        _lineList = [NSMutableArray array];
    }
    return _lineList;
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
    
//    _tagModel = [DataManager queryTag:tagId];
    
    _tagModel = [TagManager getTag:tagId];
}

- (NSDate *)startTime
{
    if (!_startTime) {
        if (self.lineList.count > 0) {
            LineModel *firstLine = self.lineList.firstObject;
            _startTime = firstLine.beginTime;
        }
    }
    
    return _startTime;
}


@end

