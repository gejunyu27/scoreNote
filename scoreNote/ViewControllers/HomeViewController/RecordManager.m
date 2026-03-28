//
//  RecordManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "RecordManager.h"
#import "TagManager.h"

@interface RecordManager ()
@property (nonatomic, strong) NSMutableArray <RecordModel *> *homeRecords;
@end

@implementation RecordManager

DEF_SINGLETON(RecordManager)
- (instancetype)init
{
    self = [super init];
    if (self) {
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_SQLITE_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.homeRecords = nil;
            self.needUpdate = YES;
        }];
    }
    return self;
}

#pragma mark -获取首页展示的记录
+ (NSMutableArray <RecordModel *> *)homeRecords
{
    if ([self sharedInstance].homeRecords.count > 0) {
        return [self sharedInstance].homeRecords;
    }
    //没有从数据库获取
    NSMutableArray <RecordModel *> *homeRecords = [DataManager queryFollowingRecords];
    
    //把已经有购买记录的放前面
    [homeRecords sortUsingComparator:^NSComparisonResult(RecordModel *_Nonnull obj1, RecordModel *_Nonnull obj2) {
        NSInteger line1 = obj1.lineList.count > 0 ? 1 : 0;
        NSInteger line2 = obj2.lineList.count > 0 ? 1 : 0;
        
        if (line1 < line2) {
            return NSOrderedDescending;
        }else  {
            return NSOrderedAscending;
        }
    }];
    
    
    [self sharedInstance].homeRecords = homeRecords;
    
    return homeRecords;
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
    
    //从列表中移除
    NSMutableArray <RecordModel *> *homeRecords = [RecordManager homeRecords];
    if ([homeRecords containsObject:record]) {
        [homeRecords removeObject:record];
    }
    
    //列表新增一个空白记录 填补主页记录数量  //旧版功能 新版不需要
//    RecordModel *newRecord = [DataManager insertNewRecord];
//    if (newRecord) {
//        [homeRecords addObject:newRecord];
//    }
    
    //检测真实期数，如果期数比标签最大期高，则更新
    [TagManager checkMaxCount:record.realNum tagId:record.tagId];
    
    return YES;
}

#pragma mark -添加新列
+ (BOOL)addNewLine:(RecordModel *)record outMoney:(CGFloat)outMoney
{
    //上一列强制结束  旧版需要，新版只有结束了上期才能购买，不再存在这个问题
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
        [record.lineList addObject:newLine];
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
        [record.lineList removeObject:line];
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

+ (BOOL)lastLineLose:(RecordModel *)record
{
    return [self lastLineOver:NO record:record profit:0];
}

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
        BOOL isCasino = [ConfigManager getValue:ConfigTypeIsCasino]; //是否是外围模式
        currentLine.getMoney = isCasino ? (currentLine.outMoney + profit) : profit;
        
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
    }else {
        currentLine.getMoney = 0;
        currentLine.isOver = NO;
    }
    
    return result;
}

+ (BOOL)addNewRecord:(NSInteger)tagId
{
    RecordModel *record = [DataManager insertNewRecord:tagId];
    
    if (!record) {
        return NO;
    }
    
    [[self sharedInstance].homeRecords addObject:record];
    return YES;
    
}

//修改列支出
+ (BOOL)editLineOutMoney:(CGFloat)outMoney line:(LineModel *)line
{
    CGFloat oldOut = line.outMoney;
    line.outMoney = outMoney;
    
    BOOL result = [DataManager updateLine:line];
    
    if (!result) {
        line.outMoney = oldOut;
    }
    
    return result;
}
//修改列收入
+ (BOOL)editLineGetMoney:(CGFloat)getMoney line:(LineModel *)line
{
    CGFloat oldGet = line.getMoney;
    line.getMoney = getMoney;
    
    BOOL result = [DataManager updateLine:line];
    
    if (!result) {
        line.getMoney = oldGet;
    }
    
    return result;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
