//
//  CommonHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <UIKit/UIKit.h>
@class TotalSectionModel;

NS_ASSUME_NONNULL_BEGIN

#define kCommonHeaderH 35
#define kCommonHeaderView @"CommonHeaderView"

@interface CommonHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^clickBlock)(void);

//统计
- (void)setTotalSection:(TotalSectionModel *)model;

//数据库
- (void)setSqlRecord:(RecordModel *)record section:(NSInteger)section;

- (void)setSqlLine:(LineModel *)line section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
