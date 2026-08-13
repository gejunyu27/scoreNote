//
//  StatisticsYearView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/6.
//

#import <UIKit/UIKit.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YearSelectBlock)(NSInteger index);

@interface StatisticsYearView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) YearSelectBlock selectBlock;
- (void)update:(NSArray <YearModel *> *)yearModels;


@end

NS_ASSUME_NONNULL_END
