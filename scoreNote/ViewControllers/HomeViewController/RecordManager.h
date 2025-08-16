//
//  RecordManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordManager : NSObject

AS_SINGLETON(RecordManager)
//数据是否因外部情况产生变化 ui未能及时更新 例如接收到通知
@property (nonatomic, assign) BOOL needUpdate;

//获取首页展示的记录
+ (NSMutableArray <RecordModel *> *)homeRecords;

//结束一轮记录
+ (BOOL)closeRecord:(RecordModel *)record;
//添加新列
+ (BOOL)addNewLine:(RecordModel *)record outMoney:(CGFloat)outMoney;

//修改笔记
+ (BOOL)editNote:(NSString *)note record:(RecordModel *)record;

//删减最后一列
+ (BOOL)deleteLastLine:(RecordModel *)record;

//修改每期利润
+ (BOOL)editProfitPerLine:(CGFloat)profitPerLine record:(RecordModel *)record;
//修改固定利润
+ (BOOL)editBaseProfit:(CGFloat)baseProfit record:(RecordModel *)record;
//修改止损线
+ (BOOL)editBreakLine:(CGFloat)breakLine record:(RecordModel *)record;

//修改标签
+ (BOOL)editTag:(NSInteger)tagId record:(RecordModel *)record;
//修改真实期数
+ (BOOL)editRealNum:(RecordModel *)record;



@end

NS_ASSUME_NONNULL_END
