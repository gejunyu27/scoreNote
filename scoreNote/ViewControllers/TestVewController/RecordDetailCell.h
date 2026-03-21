//
//  RecordDetailCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kRDCellH  40
#define kRDCellId @"kRDCellId"

@interface RecordDetailCell : UITableViewCell
@property (nonatomic, strong) LineModel *line;

@end

NS_ASSUME_NONNULL_END
