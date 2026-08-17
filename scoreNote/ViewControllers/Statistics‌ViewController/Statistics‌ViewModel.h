//
//  Statistics‌ViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/6.
//

#import <Foundation/Foundation.h>
#import "FinanceModel.h"
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsViewModel : NSObject

//收益数据合集
@property (nonatomic, strong, readonly) NSArray <FinanceModel *> *financeModels;
//折线图数据
//@property (nonatomic, strong)
//年份数据
@property (nonatomic, strong, readonly) NSArray <YearModel *> *yearModels;

@property (nonatomic, assign) BOOL needUpdate;

- (void)update;

@end

NS_ASSUME_NONNULL_END
