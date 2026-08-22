//
//  StatsMonthCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "CommonCornerCell.h"
#import "MonthModel.h"

#define kSMCellH 60
#define kSMCellId @"kSMCellId"

NS_ASSUME_NONNULL_BEGIN

@interface StatsMonthCell : CommonCornerCell

- (void)update:(MonthModel *)month index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
