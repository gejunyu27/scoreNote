//
//  ConfigCommonCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"

#define kConfigCellH 60
#define kConfigCellId @"kConfigCellId"

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigCommonDelegate <NSObject>
- (void)commonCellEditValue:(ConfigModel *)model clickView:(UIView *)clickView;
- (void)commonCellReset:(ConfigModel *)model;
- (void)commonCellSwitchChanged:(ConfigModel *)model;


@end

@interface ConfigCommonCell : UITableViewCell
@property (nonatomic, strong) ConfigModel *model;
@property (nonatomic, weak) id <ConfigCommonDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
