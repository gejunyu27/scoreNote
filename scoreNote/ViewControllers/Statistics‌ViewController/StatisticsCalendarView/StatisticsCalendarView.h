//
//  StatisticsCalendarView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/16.
//

#import <UIKit/UIKit.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsCalendarView : UIView
@property (nonatomic, strong) NSArray <YearModel *> *yearModels;

@end

NS_ASSUME_NONNULL_END
