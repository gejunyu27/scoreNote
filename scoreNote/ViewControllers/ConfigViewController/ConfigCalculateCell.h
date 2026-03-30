//
//  ConfigCalculateCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kCCCellH   40
#define kCCCellId  @"kCCCellId"

@protocol ConfigCalculateDelegate <NSObject>
- (void)calculateCellEditNumber:(ConfigModel *)model clickView:(UIView *)clickView;

@end

@interface ConfigCalculateCell : UITableViewCell
@property (nonatomic, strong) ConfigModel *model;
@property (nonatomic, weak) id <ConfigCalculateDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
