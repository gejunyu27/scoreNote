//
//  TotalHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/22.
//

#import <Foundation/Foundation.h>
#import "TotalSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kTotalHeaderH  50
#define kTotalHeaderId @"kTotalHeaderId"

@interface TotalHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak) TotalSectionModel *model;
@property (nonatomic, copy) void (^clickBlock)(void);
@end

NS_ASSUME_NONNULL_END
