//
//  StatsReportViewController.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "BaseViewController.h"
#import "StatsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatsReportViewController : BaseViewController
- (void)getDataFrom:(StatsViewModel *)statsViewModel;

@end

NS_ASSUME_NONNULL_END
