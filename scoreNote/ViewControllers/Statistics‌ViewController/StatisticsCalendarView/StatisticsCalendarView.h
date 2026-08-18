//
//  StatisticsCalendarView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/16.
//

#import <UIKit/UIKit.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol StatisticsCalendarDelegate <NSObject>
- (void)statisticsCalendarSelectedYear:(nullable YearModel *)year orMonth:(nullable MonthModel *)month;

@end

#pragma mark -StatisticsCalendarDelegate


@interface StatisticsCalendarView : UIView
@property (nonatomic, strong) NSArray <YearModel *> *yearModels;
@property (nonatomic, weak) id <StatisticsCalendarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
