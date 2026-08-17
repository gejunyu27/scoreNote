//
//  ConfigModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
#import "ConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) ConfigType type;

- (instancetype)initWithType:(ConfigType)type;

@end

NS_ASSUME_NONNULL_END
