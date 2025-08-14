//
//  TagDetailCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/23.
//

#import <UIKit/UIKit.h>

#define kTDCellH 40
#define kTagDetailCell @"TagDetailCell"

NS_ASSUME_NONNULL_BEGIN

@interface TagDetailCell : UITableViewCell
- (void)setData:(RecordModel *)model row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
