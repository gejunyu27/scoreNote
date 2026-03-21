//
//  TagDetailCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/22.
//

#import <Foundation/Foundation.h>

#define kTDCellH 50
#define kTDCellId @"kTDCellId"

NS_ASSUME_NONNULL_BEGIN

@interface TagDetailCell : UITableViewCell
- (void)setRecord:(RecordModel *)record row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
