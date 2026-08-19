//
//  StatsCalendarView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <UIKit/UIKit.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol StatsCalendarDelegate <NSObject>
- (void)statsCalendarSelectedYear:(nullable YearModel *)year orMonth:(nullable MonthModel *)month;

@end

@interface StatsCalendarView : UIView
@property (nonatomic, strong) NSArray <YearModel *> *yearModels;
@property (nonatomic, weak) id <StatsCalendarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
