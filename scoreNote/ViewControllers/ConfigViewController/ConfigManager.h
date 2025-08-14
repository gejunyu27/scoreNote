//
//  ConfigManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConfigType) {
    ConfigTypeLineWidth,
    ConfigTypeLineHeight,
    ConfigTypeLineFont,
    ConfigTypeLineProfit,
    ConfigTypeLineInputH
};

#define LINE_HEIGHT  [ConfigManager getValue:ConfigTypeLineHeight]
#define LINE_WIDTH   [ConfigManager getValue:ConfigTypeLineWidth]
#define LINE_FONT    SCFONT_SIZED([ConfigManager getValue:ConfigTypeLineFont])
#define LINE_PROFIT  [ConfigManager getValue:ConfigTypeLineProfit]
#define LINE_INPUTH  SCREEN_FIX([ConfigManager getValue:ConfigTypeLineInputH])



NS_ASSUME_NONNULL_BEGIN

@interface ConfigManager : NSObject

//根据类型赋值
+ (void)setValue:(CGFloat)value type:(ConfigType)type;
//根据类型取值
+ (CGFloat)getValue:(ConfigType)type;

@end

NS_ASSUME_NONNULL_END
