//
//  StatsViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <Foundation/Foundation.h>
#import "FinanceModel.h"
#import "YearModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface StatsViewModel : NSObject

//收益数据合集
@property (nonatomic, strong, readonly) NSArray <FinanceModel *> *financeModels;
//折线图数据
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *monthProfitList;
//年份数据
@property (nonatomic, strong, readonly) NSArray <YearModel *> *yearModels;

@property (nonatomic, assign) BOOL needUpdate;

- (void)update;

//详情页两个方法
+ (NSArray <FinanceModel *> *)getFinanceModelsFromYear:(YearModel *)year;
+ (NSArray <FinanceModel *> *)getFinanceModelsFromMonth:(MonthModel *)month;

@end

NS_ASSUME_NONNULL_END
