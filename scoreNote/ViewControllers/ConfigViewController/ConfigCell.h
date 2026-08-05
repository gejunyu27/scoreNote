//
//  ConfigCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/5.
//

#import <UIKit/UIKit.h>
#import "ConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kConfigCellH   55
#define kConfigCellId  @"onfigCellId"

@protocol ConfigCellDelegate <NSObject>

- (void)configCellSwitchClicked:(ConfigModel *)model;

@end

@interface ConfigCell : UITableViewCell
@property (nonatomic, strong) ConfigModel *model;
@property (nonatomic, weak) id <ConfigCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
