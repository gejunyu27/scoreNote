//
//  StatsDetailHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"

#define kSDHeaderH 70
#define kSDHeaderId @"kSDHeaderId"

NS_ASSUME_NONNULL_BEGIN

@interface StatsDetailHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak) MonthModel *month;
@property (nonatomic, copy) baseBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
