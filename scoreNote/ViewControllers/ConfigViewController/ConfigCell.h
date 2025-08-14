//
//  ConfigCell.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigCell : UITableViewCell

@property (nonatomic, assign) ConfigType type;

@property (nonatomic, copy) void (^updateBlock)(void);

@end

NS_ASSUME_NONNULL_END
