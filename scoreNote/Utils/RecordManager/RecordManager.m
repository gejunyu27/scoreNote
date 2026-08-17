//
//  RecordManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "RecordManager.h"
#import "TagManager.h"
#import "YearModel.h"

@interface RecordManager ()
@property (nonatomic, copy) baseBlock updateBlock;
//@property (nonatomic, strong) NSMutableArray <YearModel *> *yearModels;
@property (nonatomic, strong) NSMutableArray <YearModel *> *finishYears; //已完成年份
@property (nonatomic, strong) NSMutableArray <RecordModel *> *followingRecords;

@end

@implementation RecordManager

DEF_SINGLETON(RecordManager)
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        
        //接收数据库变动通知 只有开发者功能会用到
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_SQLITE_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//            self.yearModels = nil;
            [self initData];
            
            if (self.updateBlock) {
                self.updateBlock();
            }
        }];
    }
    return self;
}

//接收到通知更新数据
+ (void)updateBlock:(baseBlock)updateBlock
{
    [self sharedInstance].updateBlock = updateBlock;
}

- (void)initData
{
    //从数据库根据完成时间取出所有数据
    NSMutableArray <RecordModel *> *allRecords = [DataManager queryAllRecordsOrderEndTime];
    
    //已完成数据
    _finishYears = [NSMutableArray array];
    //进行中数据
    _followingRecords = [NSMutableArray array];
    
    //分类
    for (RecordModel *record in allRecords) {
        [self saveFinishRecord:record];
    }
    
    //把进行中数据进行排序
    if (_followingRecords.count > 0) { //把已经有投注记录的放到前面
        [_followingRecords sortUsingComparator:^NSComparisonResult(RecordModel *_Nonnull obj1, RecordModel *_Nonnull obj2) {
            NSInteger line1 = obj1.lineList.count > 0 ? 1 : 0;
            NSInteger line2 = obj2.lineList.count > 0 ? 1 : 0;
            
            if (line1 < line2) {
                return NSOrderedDescending;
            }else  {
                return NSOrderedAscending;
            }
        }];
    }

}

#pragma mark -public
+ (NSMutableArray<YearModel *> *)finishYears
{
    return [self sharedInstance].finishYears;
}

//进行中的单子
+ (NSMutableArray <RecordModel *> *)followingRecords
{
    return [self sharedInstance].followingRecords;
}

#pragma mark -数据归档
- (void)saveFinishRecord:(RecordModel *)record
{
    if (!record.isOver) {
        [_followingRecords addObject:record];
        
    }else {
        //先获取年份model 如果没有会自动创建
        YearModel *year = [self getYearModel:record];
        
        //再获取月份model 如果没有会自动创建
        MonthModel *month = [self getMonthModel:record yearModel:year];
        
        //存储记录
        [month.records addObject:record];
    }
    


}

- (YearModel *)getYearModel:(RecordModel *)record
{
    //获取年份
    NSString *yearStr = [record.endTime getStringWithDateFormat:@"yyyy年"];

    for (YearModel *year in _finishYears) {
        //有就直接取
        if ([year.title isEqualToString:yearStr]) {
            return year;
        }
    }

    //没有就新建
    YearModel *newYear = [YearModel new];
    newYear.title = yearStr;
    [_finishYears addObject:newYear];

    return newYear;
}

- (MonthModel *)getMonthModel:(RecordModel *)record yearModel:(YearModel *)yearModel
{
    //获取月份
    NSString *monthStr = [record.endTime getStringWithDateFormat:@"MM月"];
        
    for (MonthModel *month in yearModel.monthModels) {
        //有就直接取
        if ([month.title isEqualToString:monthStr]) {
            return month;
        }
    }
    
    //没有就新建
    MonthModel *newMonth = [MonthModel new];
    newMonth.title = monthStr;
    [yearModel.monthModels addObject:newMonth];
    return newMonth;
}

#pragma mark -结束一轮记录
+ (BOOL)closeRecord:(RecordModel *)record
{
    //先结束所有列
    for (LineModel *line in record.lineList) {
        if (!line.isOver) {
            line.isOver = YES;

            BOOL result = [DataManager updateLine:line];
            if (!result) {
                line.isOver = NO;
                return NO;
            }
        }
    }

    //结束记录
    record.isOver = YES;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        return NO;
    }
    
    //先从进行中列表移除
    NSMutableArray <RecordModel *> *followingRecords = [RecordManager followingRecords];
    if ([followingRecords containsObject:record]) {
        [followingRecords removeObject:record];
    }
    
    //再归档到对应年份月份
    [[self sharedInstance] saveFinishRecord:record];

    //检测真实期数，如果期数比标签最大期高，则更新
    [TagManager checkMaxCount:record.realNum tagId:record.tagId];
    
    return YES;
}

#pragma mark -添加新列
+ (BOOL)addNewLine:(RecordModel *)record outMoney:(CGFloat)outMoney
{
    //上一列强制结束  旧版需要，新版只有结束了上期才能购买，不再存在这个问题。代码不影响运行，还能拍错，先放着
    if (record.lineList.count > 0) {
        LineModel *lastLine = record.lineList.lastObject;
        
        if (!lastLine.isOver) {
            lastLine.isOver = YES;
            
            BOOL result = [DataManager updateLine:lastLine];
            
            if (record.isBreaking) {
                [DataManager updateRecord:record];
                return NO;
            }
            
            if (!result) {
                return NO;
            }
        }
    }
    
    //添加新的
    LineModel *newLine = [DataManager insertNewLineWithRecord:record outMoney:outMoney];
    
    if (newLine) {
        [record addLine:newLine];
        return YES;
        
    }else {
        return NO;
    }
    
}

#pragma mark -修改笔记
+ (BOOL)editNote:(NSString *)note record:(RecordModel *)record
{
    NSString *oldNote = record.note;
    record.note = note;
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.note = oldNote;
    }
    
    return result;
}

#pragma mark -删除列
+ (BOOL)deleteLine:(LineModel *)line
{
    RecordModel *record = line.record;
    
    if (!line || !record || ![record.lineList containsObject:line]) {
        return NO;
    }
    
    
    BOOL result = [DataManager deleteLine:line];
    
    if (result) {
        [record deleteLine:line];
    }
    return result;
}

#pragma mark -修改每期利润
+ (BOOL)editProfitPerLine:(CGFloat)profitPerLine record:(RecordModel *)record
{
    CGFloat oldProfit = record.profitPerLine;
    
    record.profitPerLine = profitPerLine;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.profitPerLine = oldProfit;
    }
    
    return result;
}

#pragma mark -修改固定利润
+ (BOOL)editBaseProfit:(CGFloat)baseProfit record:(RecordModel *)record
{
    CGFloat oldProfit = record.baseProfit;
    
    record.baseProfit = baseProfit;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.baseProfit = oldProfit;
    }
    
    return result;
}

#pragma mark -修改止损线
+ (BOOL)editBreakLine:(CGFloat)breakLine record:(RecordModel *)record
{
    CGFloat oldBreakLine = record.breakLine;
    
    record.breakLine = breakLine;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.breakLine = oldBreakLine;
    }
    
    return result;
}

#pragma mark -修改投注模式
+ (BOOL)editSporttery:(RecordModel *)record;
{
    BOOL oldSporttery = record.isSporttery;
    
    record.isSporttery = !oldSporttery;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.isSporttery = oldSporttery;
    }
    
    return result;
    
    
}

#pragma mark -修改标签
+ (BOOL)editTag:(NSInteger)tagId record:(RecordModel *)record
{
    NSInteger oldTagId = record.tagId;
    
    record.tagId = tagId;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.tagId = oldTagId;
    }
    
    return result;
}

#pragma mark -修改真实期数
+ (BOOL)editRealNum:(NSInteger)realNum record:(RecordModel *)record
{
    NSInteger oldRealNum = record.realNum;
    
    record.realNum = realNum;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.realNum = oldRealNum;
    }
    
    return result;
}

#pragma mark -修改买法
+ (BOOL)editCurrentScore:(NSString *)currentScore record:(RecordModel *)record
{
    NSString *oldScore = record.currentScore;
    
    record.currentScore = currentScore;
    
    BOOL result = [DataManager updateRecord:record];
    
    if (!result) {
        record.currentScore = oldScore;
    }
    
    return result;
}

#pragma mark -最新购买未中
+ (BOOL)lastLineLose:(RecordModel *)record
{
    return [self lastLineOver:NO record:record profit:0];
}

#pragma mark -最新购买红单
+ (BOOL)lastLineWin:(CGFloat)profit record:(RecordModel *)record
{
    return [self lastLineOver:YES record:record profit:profit];
}

+ (BOOL)lastLineOver:(BOOL)isWin record:(RecordModel *)record profit:(CGFloat)profit
{
    if (!record || record.lineList.count == 0) {
        return NO;
    }
    
    LineModel *currentLine = record.lineList.lastObject;
    
    if (isWin) {
        currentLine.getMoney = record.isSporttery ? profit : (currentLine.outMoney + profit);
        
    }else {
        currentLine.getMoney = 0;
    }
    
    currentLine.isOver = YES;
    
    BOOL result = [DataManager updateLine:currentLine];
    
    if (result) {
        record.currentScore = @""; //买法删除
        if (!isWin) {
            record.realNum++; //失败实际期数自动+1，减少手动操作
        }
        [DataManager updateRecord:record]; //这里成功与否不影响最新一单结束，所以不做返回
        
        [record refreshData];
    }else {
        currentLine.getMoney = 0;
        currentLine.isOver = NO;
    }
    
    return result;
}

#pragma mark -新增一个记录
+ (BOOL)addNewRecord:(NSInteger)tagId
{
    RecordModel *record = [DataManager insertNewRecord:tagId];
    
    if (!record) {
        return NO;
    }
    
    [[self followingRecords] addObject:record];
    return YES;
    
}

#pragma mark -修改列支出
+ (BOOL)editLineOutMoney:(CGFloat)outMoney line:(LineModel *)line
{
    CGFloat oldOut = line.outMoney;
    line.outMoney = outMoney;
    
    BOOL result = [DataManager updateLine:line];
    
    if (!result) {
        line.outMoney = oldOut;
        
    }else {
        [line.record refreshData];
    }
    
    return result;
}

#pragma mark -修改列收入
+ (BOOL)editLineGetMoney:(CGFloat)getMoney line:(LineModel *)line
{
    CGFloat oldGet = line.getMoney;
    line.getMoney = getMoney;
    
    BOOL result = [DataManager updateLine:line];
    
    if (!result) {
        line.getMoney = oldGet;
        
    }else {
        [line.record refreshData];
    }
    
    return result;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
