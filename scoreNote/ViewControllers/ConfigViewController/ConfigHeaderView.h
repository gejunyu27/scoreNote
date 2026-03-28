//
//  ConfigHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/27.
//

#import <Foundation/Foundation.h>
#import "ConfigHeaderModel.h"

#define kConfigHeaderH  50
#define kConfigHeaderId @"kConfigHeaderId"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) ConfigHeaderModel *model;
@property (nonatomic, copy) void (^clickBlock)(void);

@end

NS_ASSUME_NONNULL_END
