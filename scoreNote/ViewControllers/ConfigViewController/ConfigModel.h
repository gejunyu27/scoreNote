//
//  ConfigModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
#import "ConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ConfigPosition) { //位置
    ConfigPositionTop,     //顶部
    ConfigPositionCenter,  //中间
    ConfigPositionBottom   //底部
};

@interface ConfigModel : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) ConfigType type;
@property (nonatomic, assign) ConfigPosition position;

@end

NS_ASSUME_NONNULL_END
