//
//  CareerViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import "CareerViewModel.h"
#import "TotalSectionModel.h"

@interface CareerViewModel ()

@end

@implementation CareerViewModel

- (void)setSectionList:(NSMutableArray<TotalSectionModel *> *)sectionList startRecord:(nullable RecordModel *)startRecord
{
    NSMutableArray <CareerModel *> *temp = [NSMutableArray array];
    
    NSString *dateFormat = @"yyyy-MM-dd";
    //1.起投时间
    CareerModel *startModel = [[CareerModel alloc] initWithTitle:@"起投时间" content:[startRecord.startTime getStringWithDateFormat:dateFormat] record:startRecord];
    [temp addObject:startModel];
    
    //投注天数
    NSInteger totalDays = [startRecord.startTime daysBetweenDate:[NSDate date]] + 1; //相差日子
    CareerModel *daysModel = [[CareerModel alloc] initWithTitle:@"投注天数" content:[NSString stringWithFormat:@"%li天", totalDays]];
    [temp addObject:daysModel];
    
    //最高总利润
    CGFloat highAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_HIGH_PROFIT];
    CareerModel *highAllModel = [[CareerModel alloc] initWithTitle:@"最高总利润" content:[SCUtilities removeFloatSuffix:highAllProfit]];
    [temp addObject:highAllModel];
    
    //最低总利润
    CGFloat lowAllProfit = [[NSUserDefaults standardUserDefaults] floatForKey:KEY_LOW_PROFIT];
    CareerModel *lowAllModel = [[CareerModel alloc] initWithTitle:@"最低总利润" content:[SCUtilities removeFloatSuffix:lowAllProfit]];
    [temp addObject:lowAllModel];
    
    
    //第一次红单
    RecordModel *firstRedRecord;
    //第一次黑单
    RecordModel *firstBlackRecord;
    //2.最红单(已结束)
    RecordModel *highOverRecord;
    //3.最黑单(已结束)
    RecordModel *lowOverRecord;
    //4.最红月(已结束)
    TotalSectionModel *highOverSection;
    //5.最黑月(已结束)
    TotalSectionModel *lowOverSection;
    //6.盈期比(已结束)
    RecordModel *ratioOverRecord;
    CGFloat highOverRatio = 0.0;
    //7.最高期数
    RecordModel *highLineRecord;
    //7.5最低期数(已结束)
    RecordModel *lowLineOverRecord;
    //8.最高实际期
    RecordModel *highRealNumRecord;
    //9.红月数(已结束)
    NSInteger redOverMonths = 0;
    //10.黑月数(已结束)
    NSInteger blackOverMonths = 0;
    //11.红单数(已结束)
    NSInteger redOverRecords = 0;
    //12.黑单数(已结束)
    NSInteger blackOverRecords = 0;
    
    //13.连红数量 14.连黑数量
    NSInteger continuousRed = 0;
    NSInteger continuousBlack = 0;
    NSInteger maxRedNum = 0;
    NSInteger maxBlackNum = 0;
    BOOL isReding = YES;
    
    for (TotalSectionModel *sectionModel in sectionList) {
        if (!sectionModel.isFollowing) { //只统计结束的数据
            //最红月
            if (sectionModel.allProfit >= 0) {
                if (!highOverSection || highOverSection.allProfit <= sectionModel.allProfit ) {
                    highOverSection = sectionModel;
                    
                }
            }
            
            //最黑月
            if (sectionModel.allProfit < 0) {
                if (!lowOverSection || lowOverSection.allProfit >= sectionModel.allProfit) {
                    lowOverSection = sectionModel;
                    
                }
            }
            
            //红月数
            if (sectionModel.allProfit > 0) {
                redOverMonths++;
            }
            
            //黑月数
            if (sectionModel.allProfit < 0) {
                blackOverMonths++;
            }
            
            
            
        }
        
        
        for (RecordModel *record in sectionModel.recordList) {
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
                if (record.lineList.count > 0) {
                    CGFloat ratio = record.allProfit/record.lineList.count;
                    if (ratio >= highOverRatio) {
                        highOverRatio = ratio;
                        ratioOverRecord = record;
                    }
                }
                
                //最低期数
                if (!lowLineOverRecord || record.lineList.count <= lowLineOverRecord.lineList.count) {
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
            
            
            
            
            
        }
    }
    
    CareerModel *firstRedModel = [[CareerModel alloc] initWithTitle:@"首红" content:[firstRedRecord.endTime getStringWithDateFormat:dateFormat] record:firstRedRecord];
    [temp addObject:firstRedModel];
    
    CareerModel *firstBlackModel = [[CareerModel alloc] initWithTitle:@"首黑" content:[firstBlackRecord.endTime getStringWithDateFormat:dateFormat] record:firstBlackRecord];
    [temp addObject:firstBlackModel];
    
    CareerModel *highRModel = [[CareerModel alloc] initWithTitle:@"最红单" content:[SCUtilities removeFloatSuffix:highOverRecord.allProfit] record:highOverRecord];
    [temp addObject:highRModel];
    
    CareerModel *lowRModel = [[CareerModel alloc] initWithTitle:@"最黑单" content:[SCUtilities removeFloatSuffix:lowOverRecord.allProfit] record:lowOverRecord];
    [temp addObject:lowRModel];
    
    CareerModel *highSModel = [[CareerModel alloc] initWithTitle:@"最红月份" content:highOverSection.name tip:[SCUtilities removeFloatSuffix:highOverSection.allProfit]];
    [temp addObject:highSModel];
    
    CareerModel *lowSModel = [[CareerModel alloc] initWithTitle:@"最黑月份" content:lowOverSection.name tip:[SCUtilities removeFloatSuffix:lowOverSection.allProfit]];
    [temp addObject:lowSModel];
    
    CareerModel *ratioRModel = [[CareerModel alloc] initWithTitle:@"最高盈期比" content:[SCUtilities removeFloatSuffix:highOverRatio] record:ratioOverRecord];
    [temp addObject:ratioRModel];
    
    CareerModel *lowLModel = [[CareerModel alloc] initWithTitle:@"最低期数" content:[NSString stringWithFormat:@"%li", lowLineOverRecord.lineList.count] record:lowLineOverRecord];
    [temp addObject:lowLModel];
    
    CareerModel *highLModel = [[CareerModel alloc] initWithTitle:@"最高期数" content:[NSString stringWithFormat:@"%li", highLineRecord.lineList.count] record:highLineRecord];
    highLModel.isCanFollowing = YES;
    [temp addObject:highLModel];
    
    CareerModel *highRNModel = [[CareerModel alloc] initWithTitle:@"最高实际期数" content:[NSString stringWithFormat:@"%li", highRealNumRecord.realNum] record:highRealNumRecord];
    highRNModel.isCanFollowing = YES;
    [temp addObject:highRNModel];
    
    CareerModel *redMModel = [[CareerModel alloc] initWithTitle:@"红月数" content:[NSString stringWithFormat:@"%li", redOverMonths]];
    [temp addObject:redMModel];
    
    CareerModel *blackMModel = [[CareerModel alloc] initWithTitle:@"黑月数" content:[NSString stringWithFormat:@"%li", blackOverMonths]];
    [temp addObject:blackMModel];
    
    CareerModel *redRModel = [[CareerModel alloc] initWithTitle:@"红单数" content:[NSString stringWithFormat:@"%li", redOverRecords]];
    [temp addObject:redRModel];
    
    CareerModel *blackRModel = [[CareerModel alloc] initWithTitle:@"黑单数" content:[NSString stringWithFormat:@"%li", blackOverRecords]];
    [temp addObject:blackRModel];
    
    CareerModel *maxRedNumModel = [[CareerModel alloc] initWithTitle:@"最长连红" content:[NSString stringWithFormat:@"%li", maxRedNum]];
    [temp addObject:maxRedNumModel];
    
    CareerModel *maxBlackNumModel = [[CareerModel alloc] initWithTitle:@"最长连黑" content:[NSString stringWithFormat:@"%li", maxBlackNum]];
    [temp addObject:maxBlackNumModel];
    
    _careerList = temp.copy;
}


@end
