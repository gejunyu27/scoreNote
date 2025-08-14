//
//  TagDetailViewController.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/23.
//

#import "BaseViewController.h"
@class TagRankModel;

NS_ASSUME_NONNULL_BEGIN

@interface TagDetailViewController : BaseViewController
- (void)setDataWithTagId:(NSInteger)tagId name:(nullable NSString *)name records:(nullable NSArray <RecordModel *> *)records;


@end

NS_ASSUME_NONNULL_END
