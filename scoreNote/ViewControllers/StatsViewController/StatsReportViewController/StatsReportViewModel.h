//
//  StatsReportViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import <Foundation/Foundation.h>
#import "StatsReportModel.h"
@class StatsViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface StatsReportViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray <StatsReportModel *> *reportList;

- (void)getDataFrom:(StatsViewModel *)statsViewModel;

@end

NS_ASSUME_NONNULL_END
