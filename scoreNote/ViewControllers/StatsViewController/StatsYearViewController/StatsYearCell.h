//
//  StatsYearCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "CommonCornerCell.h"

#define kSYCellH 50
#define kSYCellId @"kSYCellId"

NS_ASSUME_NONNULL_BEGIN

@interface StatsYearCell : UITableViewCell
- (void)update:(RecordModel *)record row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
