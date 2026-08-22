//
//  StatsYearHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"

#define kSYHeaderH 70
#define kSYHeaderId @"kSYHeaderId"

NS_ASSUME_NONNULL_BEGIN

@interface StatsYearHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak) MonthModel *month;
@property (nonatomic, copy) baseBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
