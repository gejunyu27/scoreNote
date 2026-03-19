//
//  HomeCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import <Foundation/Foundation.h>

#define kHomeCellH 230
#define kHomeCellId @"HomeCellId"

NS_ASSUME_NONNULL_BEGIN

@protocol HomeCellDelegate <NSObject>
- (void)homeCellInsertNewLineWithRecord:(RecordModel *)record;


@end

@interface HomeCell : UITableViewCell

@property (nonatomic, weak) id <HomeCellDelegate> delegate;
@property (nonatomic, strong) RecordModel *record;

@end

NS_ASSUME_NONNULL_END
