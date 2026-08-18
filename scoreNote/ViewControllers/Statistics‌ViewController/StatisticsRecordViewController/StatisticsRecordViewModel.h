//
//  StatisticsRecordViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <Foundation/Foundation.h>
#import "FinanceModel.h"
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsRecordViewModel : NSObject

+ (NSArray <FinanceModel *> *)getFinanceModelsFromYear:(YearModel *)year;
+ (NSArray <FinanceModel *> *)getFinanceModelsFromMonth:(MonthModel *)month;

@end

NS_ASSUME_NONNULL_END
