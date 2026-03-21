//
//  TestDetailViewController.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/21.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestDetailViewController : BaseViewController
@property (nonatomic, strong) RecordModel *record;
@property (nonatomic, copy) void (^updateBlock)(void);

@end

NS_ASSUME_NONNULL_END
