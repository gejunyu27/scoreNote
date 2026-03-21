//
//  RecordDetailViewController.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/21.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordDetailViewController : BaseViewController
@property (nonatomic, copy) void (^updateBlock)(void);
- (void)setRecord:(RecordModel *)record canEdit:(BOOL)canEdit;


@end

NS_ASSUME_NONNULL_END
