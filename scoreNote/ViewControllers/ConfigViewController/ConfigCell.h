//
//  ConfigCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/5.
//

#import "CommonCornerCell.h"
#import "ConfigSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kConfigCellH   55
#define kConfigCellId  @"onfigCellId"

@protocol ConfigCellDelegate <NSObject>

- (void)configCellSwitchClicked:(ConfigModel *)model;

@end

@interface ConfigCell : CommonCornerCell
@property (nonatomic, weak) id <ConfigCellDelegate> delegate;

- (void)update:(ConfigSectionModel *)sectionModel index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
