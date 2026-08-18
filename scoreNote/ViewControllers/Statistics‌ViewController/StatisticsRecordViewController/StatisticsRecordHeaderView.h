//
//  StatisticsRecordHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"

#define kSRHeaderH 60
#define kSRHeaderId @"kSDHeaderId"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsRecordHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak) MonthModel *month;
@property (nonatomic, copy) baseBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
