//
//  StatsReportCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import <UIKit/UIKit.h>
#import "StatsReportModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kSRCellH  50
#define kSRCellId @"kSRCellId"

@interface StatsReportCell : UITableViewCell
- (void)update:(StatsReportModel *)report row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
