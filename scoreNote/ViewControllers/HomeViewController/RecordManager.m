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
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_CONFIG_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.needUpdate = YES;
        }];
    }
    return self;
}

#pragma mark -获取首页展示的记录
+ (NSMutableArray <RecordModel *> *)homeRecords
{
    NSInteger homeNum = 15; //首页默认显示15个
    
    //如果有直接返回
    if ([self sharedInstance].homeRecords.count >= homeNum) {
        return [self sharedInstance].homeRecords;
    }
    
    //没有从数据库获取
    //先获取所有在跟的
    NSMutableArray <RecordModel *> *homeRecords = [DataManager queryFollowingRecords];
    
    //不足15个，新建空白记录补齐
    if (homeRecords.count < homeNum) {
        NSInteger addNum = homeNum - homeRecords.count; //缺的数量
        
        NSMutableArray <RecordModel *> *newRecords = [DataManager insertNewRecords:addNum];
    
        if (newRecords.count > 0) {
            [homeRecords addObjectsFromArray:newRecords];
        }
    }
    
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
    
    //列表新增一个空白记录 填补主页记录数量
    RecordModel *newRecord = [DataManager insertNewRecord];
    if (newRecord) {
        [homeRecords addObject:newRecord];
    }
    
    //检测真实期数，如果期数比标签最大期高，则更新
    [TagManager checkMaxCount:record.realNum tagId:record.tagId];
    
    return YES;
}

#pragma mark -添加新列
+ (BOOL)addNewLine:(RecordModel *)record outMoney:(CGFloat)outMoney
{
    //上一列强制结束
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

#pragma mark -删减最后一列
+ (BOOL)deleteLastLine:(RecordModel *)record
{
    if (record.lineList.count == 0) {
        return NO;
    }
    
    LineModel *lastLine = record.lineList.lastObject;
    
    BOOL result = [DataManager deleteLine:lastLine];
    
    if (result) {
        [record.lineList removeObject:lastLine];
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
+ (BOOL)editRealNum:(RecordModel *)record
{
    BOOL result = [DataManager updateRecord:record];

    return result;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
