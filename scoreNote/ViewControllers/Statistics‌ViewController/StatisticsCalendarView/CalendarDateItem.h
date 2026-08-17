//
//  CalendarDateItem.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/17.
//

#import <UIKit/UIKit.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarDateItem : UIControl
@property (nonatomic, strong) YearModel *year;
@property (nonatomic, strong) MonthModel *month;

@end

NS_ASSUME_NONNULL_END
