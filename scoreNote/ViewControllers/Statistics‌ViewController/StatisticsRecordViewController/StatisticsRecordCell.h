//
//  StatisticsRecordCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <UIKit/UIKit.h>

#define kSRCellH 50
#define kSRCellId @"kSDCellId"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsRecordCell : UITableViewCell
- (void)update:(RecordModel *)record isYear:(BOOL)isYear row:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
