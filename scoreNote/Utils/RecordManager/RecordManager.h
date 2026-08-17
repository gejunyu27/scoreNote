//
//  RecordManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordManager : NSObject

//所有数据 废弃 拆分成下面两个已完成年份和进行中
//+ (NSMutableArray <YearModel *> *)yearModels;

//已完成年份
+ (NSMutableArray <YearModel *> *)finishYears;

//进行中的单子
+ (NSMutableArray <RecordModel *> *)followingRecords;

//接收到通知更新数据
+ (void)updateBlock:(baseBlock)updateBlock;

//结束一轮记录
+ (BOOL)closeRecord:(RecordModel *)record;
//添加新列
+ (BOOL)addNewLine:(RecordModel *)record outMoney:(CGFloat)outMoney;

//修改笔记
+ (BOOL)editNote:(NSString *)note record:(RecordModel *)record;

//删除列
+ (BOOL)deleteLine:(LineModel *)line;

//修改每期利润
+ (BOOL)editProfitPerLine:(CGFloat)profitPerLine record:(RecordModel *)record;
//修改固定利润
+ (BOOL)editBaseProfit:(CGFloat)baseProfit record:(RecordModel *)record;
//修改止损线
+ (BOOL)editBreakLine:(CGFloat)breakLine record:(RecordModel *)record;
//修改投注模式
+ (BOOL)editSporttery:(RecordModel *)record;

//修改标签
+ (BOOL)editTag:(NSInteger)tagId record:(RecordModel *)record;
//修改真实期数
+ (BOOL)editRealNum:(NSInteger)realNum record:(RecordModel *)record;
//修改买法
+ (BOOL)editCurrentScore:(NSString *)currentScore record:(RecordModel *)record;
//最新购买未中
+ (BOOL)lastLineLose:(RecordModel *)record;
//最新购买红单
+ (BOOL)lastLineWin:(CGFloat)profit record:(RecordModel *)record;
//新增一个记录
+ (BOOL)addNewRecord:(NSInteger)tagId;
//修改列支出
+ (BOOL)editLineOutMoney:(CGFloat)outMoney line:(LineModel *)line;
//修改列收入
+ (BOOL)editLineGetMoney:(CGFloat)getMoney line:(LineModel *)line;

@end

NS_ASSUME_NONNULL_END
