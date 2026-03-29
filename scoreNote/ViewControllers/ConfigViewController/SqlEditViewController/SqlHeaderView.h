//
//  SqlHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSqlHeaderH  35
#define kSqlHeaderId @"kSqlHeaderId"

@interface SqlHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^clickBlock)(void);

//数据库
- (void)setSqlRecord:(RecordModel *)record section:(NSInteger)section;

- (void)setSqlLine:(LineModel *)line section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
