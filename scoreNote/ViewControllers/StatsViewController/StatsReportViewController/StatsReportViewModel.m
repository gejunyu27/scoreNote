//
//  StatsReportViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsReportViewModel.h"
#import "StatsViewModel.h"
#import "StatsReportModel.h"

@implementation StatsReportViewModel
- (void)getDataFrom:(StatsViewModel *)statsViewModel
{
    NSMutableArray <StatsReportModel *> *temp = [NSMutableArray array];
    
    NSString *dateFormat = @"yyyy-MM-dd";
    
    RecordModel *startRecord = statsViewModel.startRecord;
    
    
    
    //1.起投时间
    StatsReportModel *startModel = [[StatsReportModel alloc] initWithTitle:@"起投时间" content:[startRecord.startTime getStringWithDateFormat:dateFormat] record:startRecord];
    [temp addObject:startModel];
    
    //2.投注天数
    NSInteger totalDays = [startRecord.startTime daysBetweenDate:[NSDate date]] + 1; //相差日子
    StatsReportModel *daysModel = [[StatsReportModel alloc] initWithTitle:@"投注天数" content:[NSString stringWithFormat:@"%li天", totalDays]];
    [temp addObject:daysModel];
    
    //3.总投注
    CGFloat allOut = 0;
    CGFloat bitcoinOut = 0;
    //4.总收入
    CGFloat allGet = 0;
    CGFloat bitcoinGet = 0;
    
    //8.第一次红单
    RecordModel *firstRedRecord;
    //9.第一次黑单
    RecordModel *firstBlackRecord;
    //10.最红单(已结束)
    RecordModel *highOverRecord;
    //11.最黑单(已结束)
    RecordModel *lowOverRecord;
    //12.最红月(已结束)
    MonthModel *highOverMonth;
    //13.最黑月(已结束)
    MonthModel *lowOverMonth;
    //14.盈期比(已结束)xz
    RecordModel *ratioOverRecord;
    CGFloat highOverRatio = 0.0;
    //15.最低期数(已结束)
    RecordModel *lowLineOverRecord;
    //16.最高期数
    RecordModel *highLineRecord;
    //17.最高实际期
    RecordModel *highRealNumRecord;
    //18.最大投入单
    RecordModel *highOutRecord;
    //19.最大收入单
    RecordModel *highGetRecord;
    //20.红月数(已结束)
    NSInteger redOverMonths = 0;
    //21.黑月数(已结束)
    NSInteger blackOverMonths = 0;
    //22.红单数(已结束)
    NSInteger redOverRecords = 0;
    //23.黑单数(已结束)
    NSInteger blackOverRecords = 0;
    
    //24.最长连红数量 25.最长连黑数量
    NSInteger continuousRed = 0;
    NSInteger continuousBlack = 0;
    NSInteger maxRedNum = 0;
    NSInteger maxBlackNum = 0;
    BOOL isReding = YES;
    
    for (YearModel *year in statsViewModel.yearModels) {
        for (MonthModel *month in year.monthModels) {
            //只统计结束的数据
            if (!year.isFollowing) {
                //最红月
                if (month.allProfit >= 0) {
                    if (!highOverMonth || highOverMonth.allProfit <= month.allProfit ) {
                        highOverMonth = month;
                        
                    }
                }
                
                //最黑月
                if (month.allProfit < 0) {
                    if (!lowOverMonth || lowOverMonth.allProfit >= month.allProfit) {
                        lowOverMonth = month;
                        
                    }
                }
                
                //红月数
                if (month.allProfit > 0) {
                    redOverMonths++;
                }
                
                //黑月数
                if (month.allProfit < 0) {
                    blackOverMonths++;
                }
            }
            
            //所有数据都统计数据
            allOut += month.allOut;
            bitcoinOut += month.bitcoinOut;
            allGet += month.allGet;
            bitcoinGet += month.bitcoinGet;
            
            for (RecordModel *record in month.records) {
                if (record.isOver) { //只统计结束的数据
                    if (record.allProfit > 0) {//最红单
                        if (!highOverRecord || highOverRecord.allProfit <= record.allProfit) {
                            highOverRecord = record;
                            
                        }
                        
                        //第一次红单
                        NSTimeInterval rt = [record.endTime timeIntervalSince1970];
                        NSTimeInterval frrt = [firstRedRecord.endTime timeIntervalSince1970];
                        if (!firstRedRecord || rt < frrt) {
                            firstRedRecord = record;
                        }
                        
                        
                    }
                    
                    if (record.allProfit<0) { //最黑单
                        if (!lowOverRecord || lowOverRecord.allProfit >= record.allProfit) {//最黑单
                            lowOverRecord = record;
                        }
                        
                        //第一次黑单
                        NSTimeInterval rt = [record.endTime timeIntervalSince1970];
                        NSTimeInterval fbrt = [firstRedRecord.endTime timeIntervalSince1970];
                        if (!firstBlackRecord || rt < fbrt) {
                            firstBlackRecord = record;
                        }
                    }
                    
                    //盈期比
                    if (record.lineList.count > 0 && record.isBetTag) {
                        CGFloat ratio = record.allProfit/record.lineList.count;
                        if (ratio >= highOverRatio) {
                            highOverRatio = ratio;
                            ratioOverRecord = record;
                        }
                    }
                    
                    //最低期数
                    if ((!lowLineOverRecord || record.lineList.count <= lowLineOverRecord.lineList.count) && record.isBetTag) {
                        lowLineOverRecord = record;
                    }
                    
                    
                    if (record.allProfit > 0) {
                        redOverRecords++;
                    }else if (record.allProfit < 0) {
                        blackOverRecords++;
                    }
                    
                    //连红连黑
                    if (record.allProfit > 0) { //红
                        if (isReding) { //计算连红中
                            continuousRed++; //连红数+1
                        }else { //正在计算连黑
                            //连黑终结
                            maxBlackNum = MAX(continuousBlack, maxBlackNum);
                            continuousBlack = 0;
                            
                        }
                    }else if (record.allProfit < 0) { //黑
                        if (isReding) { //计算连红中
                            //连红终结
                            maxRedNum = MAX(continuousRed, maxRedNum);
                            continuousRed = 0;
                            
                        }else { //计算连黑中
                            continuousBlack++; //连黑数+1
                        }
                    }
                }
                
                //最高期数单
                if (!highLineRecord || record.lineList.count >= highLineRecord.lineList.count) {
                    highLineRecord = record;
                }
                
                //最高实际期
                if (!highRealNumRecord || record.realNum >= highRealNumRecord.realNum) {
                    highRealNumRecord = record;
                }
                
                //最大投入单
                if (!highOutRecord || record.allOut >= highOutRecord.allOut) {
                    highOutRecord = record;
                }
                
                //最大收入单
                if (!highGetRecord || record.allGet >= highGetRecord.allGet) {
                    highGetRecord = record;
                }
                
            }
        }
    }
    

    
    StatsReportModel *allOutModel = [[StatsReportModel alloc] initWithTitle:@"总投入" content:[SCUtilities removeFloatSuffix:allOut] tip:[NSString stringWithFormat:@"其中比特币%@", [SCUtilities removeFloatSuffix:bitcoinOut]]];
    [temp addObject:allOutModel];
    
    StatsReportModel *allGetModel = [[StatsReportModel alloc] initWithTitle:@"总收入" content:[SCUtilities removeFloatSuffix:allGet] tip:[NSString stringWithFormat:@"其中比特币%@", [SCUtilities removeFloatSuffix:bitcoinGet]]];
    [temp addObject:allGetModel];
    
    //5.净利润
    StatsReportModel *allProfitModel = [[StatsReportModel alloc] initWithTitle:@"净利润" content:[SCUtilities removeFloatSuffix:allGet-allOut] tip:[NSString stringWithFormat:@"其中比特币%@", [SCUtilities removeFloatSuffix:bitcoinGet-bitcoinOut]]];
    [temp addObject:allProfitModel];
    
    //6.最高净利润
    CGFloat highAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_HIGH_PROFIT];
    StatsReportModel *highAllModel = [[StatsReportModel alloc] initWithTitle:@"最高净利润" content:[SCUtilities removeFloatSuffix:highAllProfit]];
    [temp addObject:highAllModel];
    
    //7.最低净利润
    CGFloat lowAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_LOW_PROFIT];
    StatsReportModel *lowAllModel = [[StatsReportModel alloc] initWithTitle:@"最低净利润" content:[SCUtilities removeFloatSuffix:lowAllProfit]];
    [temp addObject:lowAllModel];
    
    StatsReportModel *firstRedModel = [[StatsReportModel alloc] initWithTitle:@"首红" content:[firstRedRecord.endTime getStringWithDateFormat:dateFormat] record:firstRedRecord];
    [temp addObject:firstRedModel];
    
    StatsReportModel *firstBlackModel = [[StatsReportModel alloc] initWithTitle:@"首黑" content:[firstBlackRecord.endTime getStringWithDateFormat:dateFormat] record:firstBlackRecord];
    [temp addObject:firstBlackModel];
    
    StatsReportModel *highRModel = [[StatsReportModel alloc] initWithTitle:@"最红单" content:[SCUtilities removeFloatSuffix:highOverRecord.allProfit] record:highOverRecord];
    [temp addObject:highRModel];
    
    StatsReportModel *lowRModel = [[StatsReportModel alloc] initWithTitle:@"最黑单" content:[SCUtilities removeFloatSuffix:lowOverRecord.allProfit] record:lowOverRecord];
    [temp addObject:lowRModel];
    
    StatsReportModel *highSModel = [[StatsReportModel alloc] initWithTitle:@"最红月份" content:[NSString stringWithFormat:@"%@%@",highOverMonth.yearModel.title, highOverMonth.title] tip:[SCUtilities removeFloatSuffix:highOverMonth.allProfit]];
    [temp addObject:highSModel];
    
    StatsReportModel *lowSModel = [[StatsReportModel alloc] initWithTitle:@"最黑月份" content:[NSString stringWithFormat:@"%@%@",lowOverMonth.yearModel.title, lowOverMonth.title] tip:[SCUtilities removeFloatSuffix:lowOverMonth.allProfit]];
    [temp addObject:lowSModel];
    
    StatsReportModel *ratioRModel = [[StatsReportModel alloc] initWithTitle:@"最高盈期比" content:[SCUtilities removeFloatSuffix:highOverRatio] record:ratioOverRecord];
    [temp addObject:ratioRModel];
    
    StatsReportModel *lowLModel = [[StatsReportModel alloc] initWithTitle:@"最低期数" content:[NSString stringWithFormat:@"%li", lowLineOverRecord.lineList.count] record:lowLineOverRecord];
    [temp addObject:lowLModel];
    
    StatsReportModel *highLModel = [[StatsReportModel alloc] initWithTitle:@"最高期数" content:[NSString stringWithFormat:@"%li", highLineRecord.lineList.count] record:highLineRecord];
    highLModel.isCanFollowing = YES;
    [temp addObject:highLModel];
    
    StatsReportModel *highRNModel = [[StatsReportModel alloc] initWithTitle:@"最高实际期数" content:[NSString stringWithFormat:@"%li", highRealNumRecord.realNum] record:highRealNumRecord];
    highRNModel.isCanFollowing = YES;
    [temp addObject:highRNModel];
    
    StatsReportModel *highORModel = [[StatsReportModel alloc] initWithTitle:@"最大投入单" content:[SCUtilities removeFloatSuffix:highOutRecord.allOut] record:highOutRecord];
    [temp addObject:highORModel];
    
    StatsReportModel *highGRModel = [[StatsReportModel alloc] initWithTitle:@"最大收入单" content:[SCUtilities removeFloatSuffix:highGetRecord.allGet] record:highGetRecord];
    [temp addObject:highGRModel];
    
    StatsReportModel *redMModel = [[StatsReportModel alloc] initWithTitle:@"红月数" content:[NSString stringWithFormat:@"%li", redOverMonths]];
    [temp addObject:redMModel];
    
    StatsReportModel *blackMModel = [[StatsReportModel alloc] initWithTitle:@"黑月数" content:[NSString stringWithFormat:@"%li", blackOverMonths]];
    [temp addObject:blackMModel];
    
    StatsReportModel *redRModel = [[StatsReportModel alloc] initWithTitle:@"红单数" content:[NSString stringWithFormat:@"%li", redOverRecords]];
    [temp addObject:redRModel];
    
    StatsReportModel *blackRModel = [[StatsReportModel alloc] initWithTitle:@"黑单数" content:[NSString stringWithFormat:@"%li", blackOverRecords]];
    [temp addObject:blackRModel];
    
    StatsReportModel *maxRedNumModel = [[StatsReportModel alloc] initWithTitle:@"最长连红" content:[NSString stringWithFormat:@"%li", maxRedNum]];
    [temp addObject:maxRedNumModel];
    
    StatsReportModel *maxBlackNumModel = [[StatsReportModel alloc] initWithTitle:@"最长连黑" content:[NSString stringWithFormat:@"%li", maxBlackNum]];
    [temp addObject:maxBlackNumModel];
    
    _reportList = temp.copy;
}

@end
