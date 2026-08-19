//
//  StatsDetailCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import <UIKit/UIKit.h>

#define kSDCellH 60
#define kSDCellId @"kSDCellId"

NS_ASSUME_NONNULL_BEGIN

@interface StatsDetailCell : UITableViewCell

- (void)update:(RecordModel *)record isYear:(BOOL)isYear row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
