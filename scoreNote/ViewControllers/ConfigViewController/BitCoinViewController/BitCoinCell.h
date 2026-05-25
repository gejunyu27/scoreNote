//
//  BitCoinCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/5/25.
//

#import <UIKit/UIKit.h>
@class BitCoinModel;

NS_ASSUME_NONNULL_BEGIN

#define kBCCellH 50
#define kBCCellId @"kBCCellId"

@interface BitCoinCell : UITableViewCell
- (void)setModel:(BitCoinModel *)model row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
