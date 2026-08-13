//
//  StatisticsHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/11.
//

#import <UIKit/UIKit.h>
#import "FinanceModel.h"
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol StatisticsHeaderDelegate <NSObject>

- (void)statisticsHeaderYearSelected:(NSInteger)index;

@end

@interface StatisticsHeaderView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id <StatisticsHeaderDelegate> delegate;

- (void)updateWithFinanceModels:(NSArray <FinanceModel *> *)financeModels yearModels:(NSArray <YearModel *> *)yearModels;

@end

NS_ASSUME_NONNULL_END
