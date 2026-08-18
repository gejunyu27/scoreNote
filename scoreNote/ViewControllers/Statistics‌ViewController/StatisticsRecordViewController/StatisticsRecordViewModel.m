//
//  StatisticsRecordViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import "StatisticsRecordViewModel.h"

@implementation StatisticsRecordViewModel

+ (NSArray <FinanceModel *> *)getFinanceModelsFromYear:(YearModel *)year
{
    //利润
    FinanceModel *profitModel = [[FinanceModel alloc] initWithTitle:(year.isFollowing ? @"投入状况" : @"本年利润") content:[SCUtilities removeFloatSuffix:year.allProfit]];
    
    //支出
    FinanceModel *outModel = [[FinanceModel alloc] initWithTitle:@"支出" content:[SCUtilities removeFloatSuffix:year.allOut]];
    
    //收入
    FinanceModel *getModel = [[FinanceModel alloc] initWithTitle:@"收入" content:[SCUtilities removeFloatSuffix:year.allGet]];
    
    return @[profitModel, outModel , getModel];
}

+ (NSArray <FinanceModel *> *)getFinanceModelsFromMonth:(MonthModel *)month
{
    //利润
    FinanceModel *profitModel = [[FinanceModel alloc] initWithTitle:(month.yearModel.isFollowing ? @"投入状况" : @"本月利润") content:[SCUtilities removeFloatSuffix:month.allProfit]];
    
    //支出
    FinanceModel *outModel = [[FinanceModel alloc] initWithTitle:@"支出" content:[SCUtilities removeFloatSuffix:month.allOut]];
    
    //收入
    FinanceModel *getModel = [[FinanceModel alloc] initWithTitle:@"收入" content:[SCUtilities removeFloatSuffix:month.allGet]];
    
    return @[profitModel, outModel , getModel];
}

@end
