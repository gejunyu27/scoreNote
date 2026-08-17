//
//  MonthModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/8.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonthModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <RecordModel *> *records;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat allProfit;
@end

NS_ASSUME_NONNULL_END
