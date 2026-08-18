//
//  Statistics‌ViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/6.
//

#import "Statistics‌ViewModel.h"
#import "RecordManager.h"

@interface StatisticsViewModel ()
@property (nonatomic, strong) RecordModel *startRecord;
@end

@implementation StatisticsViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_SQLITE_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.needUpdate = YES;
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_RECORD_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.needUpdate = YES;
        }];
        
        [self update];
        
        
    }
    return self;
}

- (void)update
{
    //清除数据
    [self clearData];
    
    self.needUpdate = NO;
    
    //合并数据
    [self getYearModels];
    
    //获取统计数据
    NSInteger allRecordsNum = 0;   //总单数
    CGFloat totalProfit = 0;       //总利润
    
    for (YearModel *year in self.yearModels) {
        totalProfit += year.allProfit; //计算总利润
        for (MonthModel *month in year.monthModels) {
            allRecordsNum += month.records.count; //计算总单数
            for (RecordModel *record in month.records) {
                [self getStartRecord:record]; //获取起始单
            }
        }
    }
    
    //这里顺手可以更新下本地的数据
    [self updateLocalData:totalProfit];
    
    //投注总月份
    NSDate *startDate = _startRecord.startTime;
    NSInteger totalMonths = [startDate monthsBetweenDate:[NSDate date]] + 1; //相差月数 原相差月数不算上当月，所以要+1
    //每月利润
    CGFloat perMonthProfit = totalProfit/totalMonths;
    //起投日期
    NSString *startDateString = startDate ? [startDate getStringWithDateFormat:@"yyyy年MM月"] : @"还未起投";
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
    FinanceModel *totalProfitModel    = [[FinanceModel alloc] initWithTitle:@"总收益（非现金流）" content:[SCUtilities removeFloatSuffix:totalProfit]];
    FinanceModel *startDateModel      = [[FinanceModel alloc] initWithTitle:@"起投日期" content:startDateString];
    FinanceModel *periodModel         = [[FinanceModel alloc] initWithTitle:@"投注时长" content:periodString];
    FinanceModel *allRecordsNumModel  = [[FinanceModel alloc] initWithTitle:@"总单数" content:[NSString stringWithFormat:@"%li单", allRecordsNum]];
    FinanceModel *perMonthProfitModel = [[FinanceModel alloc] initWithTitle:@"月均收益" content:[SCUtilities removeFloatSuffix:perMonthProfit]];
    
    _financeModels = @[totalProfitModel, startDateModel, periodModel, allRecordsNumModel, perMonthProfitModel];
}

- (void)getYearModels
{
    NSMutableArray <YearModel *> *temp = [NSMutableArray array];
    
    //先添加已完成
    [temp addObjectsFromArray:[RecordManager finishYears]];
    
    //再添加进行中的 为了统计准确性，进行中的把还未投注的剔除
    NSArray *followingRecords = [RecordManager followingRecords];
    if (followingRecords.count > 0) {
        YearModel *fYear = [YearModel new];
        fYear.title = @"进行中";
        fYear.isFollowing = YES;
        MonthModel *fMonth = [MonthModel new];
        fMonth.title = [[NSDate date] getStringWithDateFormat:@"MM月"];
        [fYear.monthModels addObject:fMonth];
        
        for (RecordModel *fRecord in followingRecords) { //只添加有购买记录的
            if (fRecord.lineList.count > 0) {
                [fMonth.records addObject:fRecord];
            }
        }
        
        if (fMonth.records.count > 0) {
            [temp addObject:fYear];
        }
    }
    
    //全部完成后，更新数据
    for (YearModel *year in temp) {
        [year updateData];
    }
    
    _yearModels = temp.copy;
}

- (void)getStartRecord:(RecordModel *)record
{
    if (!record.startTime) {
        return;
    }
    NSTimeInterval rt = [record.startTime timeIntervalSince1970];
    NSTimeInterval srt = [_startRecord.startTime timeIntervalSince1970];
    if (!_startRecord || rt < srt) {
        _startRecord = record;
    }
}

- (void)updateLocalData:(CGFloat)totalProfit
{
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
}

- (void)clearData
{
    //金融数据
    _financeModels = nil;
    _yearModels    = nil;
    _startRecord   = nil;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
