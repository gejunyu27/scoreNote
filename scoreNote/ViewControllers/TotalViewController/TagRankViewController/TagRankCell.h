//
//  TagRankCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/23.
//

#import <UIKit/UIKit.h>
@class TagRankModel;

NS_ASSUME_NONNULL_BEGIN

#define kTRCellH 45

@interface TagRankCell : UITableViewCell
- (void)setData:(TagRankModel *)model row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
