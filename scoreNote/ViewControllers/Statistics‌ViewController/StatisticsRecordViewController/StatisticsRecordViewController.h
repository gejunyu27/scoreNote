//
//  StatisticsRecordViewController.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import "BaseViewController.h"
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsRecordViewController : BaseViewController
@property (nonatomic, strong) YearModel *year;
@property (nonatomic, strong) MonthModel *month;
@end

NS_ASSUME_NONNULL_END
