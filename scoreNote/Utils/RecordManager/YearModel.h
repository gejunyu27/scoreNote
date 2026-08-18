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
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat allOut;
@property (nonatomic, assign) CGFloat allGet;
@property (nonatomic, assign) CGFloat allProfit;

@property (nonatomic, assign) BOOL isFollowing;

- (void)updateData;

@end

NS_ASSUME_NONNULL_END
