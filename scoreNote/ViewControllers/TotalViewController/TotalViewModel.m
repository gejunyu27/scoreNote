//
//  TotalViewModel.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "TotalViewModel.h"

#define kLocalSectionHide @"kLocalSectionHide"
#define kDateFormat       @"yyyy年MM月"

@interface TotalViewModel ()
//总利润
//@property (nonatomic, assign) CGFloat totalProfit;
////起投日期
//@property (nonatomic, copy) NSString *startDateString;
////投注总月份
//@property (nonatomic, assign) NSInteger totalMonths;
//@property (nonatomic, copy) NSString *periodString;
////月均利润
//@property (nonatomic, assign) CGFloat perMonthProfit;
////总单数
//@property (nonatomic, assign) NSInteger allRecordsNum;

@end

@implementation TotalViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionList = [NSMutableArray array];
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
    
    TotalSectionModel *followSectionModel = [TotalSectionModel new];
    followSectionModel.isFollowing = YES;
    followSectionModel.name = @"进行中";
    [_sectionList addObject:followSectionModel];
    
    NSMutableArray <RecordModel *> *followingRecords = [DataManager queryFollowingRecords];
    for (RecordModel *record in followingRecords) {
        if (record.lineList.count > 0) {
            [followSectionModel addRecord:record];
            [self getStartRecord:record]; //获取起始单
            
        }
    }

    //计算总利润
    CGFloat totalProfit = followSectionModel.allProfit;
    
    //计算总单数
    NSInteger allRecordsNum = followSectionModel.recordList.count;
    
    //2.获取根据时间倒序的已完成记录
    NSMutableArray <RecordModel *> *finishRecords = [DataManager queryFinishRecords];

    allRecordsNum += finishRecords.count; //总单数补充上

    //遍历
    for (RecordModel *record in finishRecords) {
        [self getStartRecord:record]; //起始单
        
        //获取年份
        NSString *endTime = [record.endTime getStringWithDateFormat:kDateFormat];
        
        TotalSectionModel *sModel;
        for (TotalSectionModel *model in _sectionList) { //已有月份直接取
            if ([model.name isEqualToString:endTime]) {
                sModel = model;
                break;;
            }
        }
        
        if (!sModel) { //没有就新建
            sModel = [TotalSectionModel new];
            sModel.name = endTime;
            [_sectionList addObject:sModel];
        }
        
        [sModel addRecord:record];
        totalProfit += record.allProfit;
        
    }
    
    //历史最高总利润
    CGFloat highAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_HIGH_PROFIT];
    if (totalProfit > highAllProfit) {
        [[NSUserDefaults standardUserDefaults] setFloat:totalProfit forKey:KEY_HIGH_PROFIT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //历史最低总利润
    CGFloat lowAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_LOW_PROFIT];
    if (totalProfit < lowAllProfit) {
        [[NSUserDefaults standardUserDefaults] setFloat:totalProfit forKey:KEY_LOW_PROFIT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
//    _historyProfit = -644735.28;
//    NSDate *nineDate = [NSDate getDateWithYear:2023 month:9 day:2]; //9月2日

    //投注总月份
    NSDate *startDate = _startRecord.startTime;
    NSInteger totalMonths = [startDate monthsBetweenDate:[NSDate date]] + 1; //相差月数 原相差月数不算上当月，所以要+1
    //每月利润
    CGFloat perMonthProfit = totalProfit/totalMonths;
    
    //起投日期
    NSString *startDateString = startDate ? [startDate getStringWithDateFormat:kDateFormat] : @"还未起投";
    
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
    
    NSString *periodString = temp.copy;
    
    //生成数据
    FinanceModel *totalProfitModel = [[FinanceModel alloc] initWithTitle:@"总收益（非现金流）" content:[SCUtilities removeFloatSuffix:totalProfit]];
    FinanceModel *allRecordsNumModel = [[FinanceModel alloc] initWithTitle:@"总单数" content:[NSString stringWithFormat:@"%li单", allRecordsNum]];
    FinanceModel *startDateModel = [[FinanceModel alloc] initWithTitle:@"起投日期" content:startDateString];
    FinanceModel *periodModel = [[FinanceModel alloc] initWithTitle:@"投注时长" content:periodString];
    FinanceModel *perMonthProfitModel = [[FinanceModel alloc] initWithTitle:@"月均收益" content:[SCUtilities removeFloatSuffix:perMonthProfit]];
    
    _financeModels = @[totalProfitModel, allRecordsNumModel, startDateModel, periodModel, perMonthProfitModel];
    
    
}

- (void)getStartRecord:(RecordModel *)record
{
    NSTimeInterval rt = [record.startTime timeIntervalSince1970];
    NSTimeInterval srt = [_startRecord.startTime timeIntervalSince1970];
    if (!_startRecord || rt < srt) {
        _startRecord = record;
    }
}

- (void)clearData
{
    //清除旧数据
    [_sectionList removeAllObjects];
    
//    _totalProfit   = 0;
//    _perMonthProfit = 0;
//    _allRecordsNum = 0;
//    
//    _startRecord = nil;
//    _startDateString = nil;
//    _periodString = nil;
    
    _financeModels = nil;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

