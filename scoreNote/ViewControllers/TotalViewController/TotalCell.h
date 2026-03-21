//
//  TotalCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/22.
//

#import <Foundation/Foundation.h>

#define kTotalCellH 45
#define kTotalCellId @"kTotalCellId"

NS_ASSUME_NONNULL_BEGIN

@interface TotalCell : UITableViewCell
@property (nonatomic, strong) RecordModel *record;

@end

NS_ASSUME_NONNULL_END
