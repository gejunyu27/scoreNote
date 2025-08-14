//
//  TotalViewModel.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
#import "TotalSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TotalViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <TotalSectionModel *> *sectionList;

//是否展开
@property (nonatomic, assign) BOOL isOn;

//总利润
@property (nonatomic, assign, readonly) CGFloat totalProfit;

//起投日期
@property (nonatomic, strong, readonly) RecordModel *startRecord; //第一单
@property (nonatomic, copy, readonly) NSString *startDateString;

//投注总月份
//@property (nonatomic, assign, readonly) NSInteger totalMonths;
@property (nonatomic, copy, readonly) NSString *periodString;

//月均利润
@property (nonatomic, assign, readonly) CGFloat perMonthProfit;

//总单数
@property (nonatomic, assign, readonly) NSInteger allRecordsNum;

//是否需要更新数据 以收到通知为准
@property (nonatomic, assign) BOOL needUpdate;

//更新数据
- (void)update;


@end


NS_ASSUME_NONNULL_END
