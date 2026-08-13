//
//  YearModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/8.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YearModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <MonthModel *>*monthModels;
@property (nonatomic, assign) BOOL isFollowing; //进行中
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat allProfit;

@end

NS_ASSUME_NONNULL_END
