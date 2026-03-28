//
//  TestCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/27.
//

#import <Foundation/Foundation.h>
@class ConfigModel;

#define kConfigCellH 45
#define kConfigCellId @"kConfigCellId"

NS_ASSUME_NONNULL_BEGIN

@interface TestCell : UITableViewCell
@property (nonatomic, strong) ConfigModel *model;

@end

NS_ASSUME_NONNULL_END
