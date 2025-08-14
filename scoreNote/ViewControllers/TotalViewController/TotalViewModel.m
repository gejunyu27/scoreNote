//
//  TotalViewModel.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "TotalViewModel.h"

#define kLocalSectionHide @"kLocalSectionHide"

@implementation TotalViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needUpdate = YES;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_SQLITE_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.needUpdate = YES;
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_RECORD_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.needUpdate = YES;
        }];
    }
    return self;
}

//获取数据
- (void)update
{
    [self clearData];
    
    //1.先添加未结束的记录
    NSMutableArray <RecordModel *> *followingRecords = [DataManager queryFollowingRecords];
    TotalSectionModel *followSectionModel = [TotalSectionModel new];
    followSectionModel.isFollowing = YES;
    followSectionModel.name = @"进行中";
    //移除空白的
    for (RecordModel *record in followingRecords) {
        if (record.lineList.count > 0) {
            [followSectionModel.recordList addObject:record];
            followSectionModel.allProfit += record.allProfit;
            
            NSTimeInterval rt = [record.startTime timeIntervalSince1970];
            NSTimeInterval srt = [_startRecord.startTime timeIntervalSince1970];
            if (!_startRecord || rt < srt) {
                _startRecord = record;
            }
        }
    }
    [_sectionList addObject:followSectionModel];
    
    _totalProfit += followSectionModel.allProfit;
    
    if (followSectionModel.recordList.count > 0) {
//        firstModel = followSectionModel.recordList.firstObject;
//        startDate = firstModel.startTime;
        
        _allRecordsNum += followSectionModel.recordList.count;
    }
    
    //3.获取根据时间倒序的已完成记录
    NSMutableArray <RecordModel *> *finishRecords = [DataManager queryFinishRecords];

    _allRecordsNum += finishRecords.count;
    
//    if (finishRecords.count > 0) {
//        firstModel = finishRecords.lastObject;
//        startDate = firstModel.endTime;
//    }
    
    //遍历
    for (RecordModel *record in finishRecords) {
        NSTimeInterval rt = [record.startTime timeIntervalSince1970];
        NSTimeInterval srt = [_startRecord.startTime timeIntervalSince1970];
        if (!_startRecord || rt < srt) {
            _startRecord = record;
        }
        
        //获取年份
        NSString *endTime = [record.endTime getStringWithDateFormat:@"yyyy年MM月"];
        
        TotalSectionModel *sModel;
        for (TotalSectionModel *model in _sectionList) {
            if ([model.name isEqualToString:endTime]) {
                sModel = model;
                break;;
            }
        }
        
        if (!sModel) {
            sModel = [TotalSectionModel new];
            sModel.name = endTime;
            [_sectionList addObject:sModel];
        }
        [sModel.recordList addObject:record];
        sModel.allProfit += record.allProfit;
        _totalProfit += record.allProfit;
        
    }
    
    //历史最高总利润
    CGFloat highAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_HIGH_PROFIT];
    if (_totalProfit > highAllProfit) {
        [[NSUserDefaults standardUserDefaults] setFloat:_totalProfit forKey:KEY_HIGH_PROFIT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //历史最低总利润
    CGFloat lowAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_LOW_PROFIT];
    if (_totalProfit < lowAllProfit) {
        [[NSUserDefaults standardUserDefaults] setFloat:_totalProfit forKey:KEY_LOW_PROFIT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
//    _historyProfit = -644735.28;
//    NSDate *nineDate = [NSDate getDateWithYear:2023 month:9 day:2]; //9月2日

    //投注总月份
    NSDate *startDate = _startRecord.startTime;
    NSInteger totalMonths = [startDate monthsBetweenDate:[NSDate date]] + 1; //相差月数 原相差月数不算上当月，所以要+1
    //每月利润
    _perMonthProfit = _totalProfit/totalMonths;
    
    //起投日期
    _startDateString = [startDate getStringWithDateFormat:@"yyyy年MM月"];
    
    //投注时长
    NSInteger year = totalMonths/12;
    NSInteger month = totalMonths%12;
    NSMutableString *temp = [NSMutableString string];
    
    if (year > 0) {
        [temp appendFormat:@"%li年", year];
    }
    if (month > 0) {
        [temp appendFormat:@"%li个月", month];
    }
    
    _periodString = temp.copy;
}

- (void)clearData
{
    //清除旧数据
    if (_sectionList) {
        [_sectionList removeAllObjects];
    }else {
        _sectionList = [NSMutableArray array];
    }
    
    _totalProfit   = 0;
    _perMonthProfit = 0;
    _allRecordsNum = 0;
    
    _startRecord = nil;
    _startDateString = nil;
    _periodString = nil;
    
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    
    for (TotalSectionModel *section in _sectionList) {
        section.isOn = isOn;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

