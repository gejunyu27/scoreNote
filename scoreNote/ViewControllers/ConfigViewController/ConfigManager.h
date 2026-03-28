//
//  ConfigManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
@class ConfigHeaderModel;

typedef NS_ENUM(NSInteger, ConfigType) {
    ConfigTypeLineProfit,  //每期利润
    ConfigTypeBaseProfit,  //固定利润
    ConfigTypeBreakLine,   //止损线
    ConfigTypeInputH,      //自定义键盘高度
    ConfigTypeIsCasino,    //是否是外围
    ConfigTypeOrderListH,  //网页嵌入模式下订单高度
    ConfigTypeOrderWebH,   //网页嵌入模式下网页高度
};

//这3个常用且用的地方多
#define LINE_PROFIT  [ConfigManager getValue:ConfigTypeLineProfit]
#define BASE_PROFIT  [ConfigManager getValue:ConfigTypeBaseProfit]
#define BREAKLINE    [ConfigManager getValue:ConfigTypeBreakLine]


NS_ASSUME_NONNULL_BEGIN

@interface ConfigManager : NSObject

//根据类型赋值
+ (void)setValue:(CGFloat)value type:(ConfigType)type;
//根据类型取值
+ (CGFloat)getValue:(ConfigType)type;

//获取配置列表
+ (NSArray <ConfigHeaderModel *> *)getConfigHeaderModels;

@end

NS_ASSUME_NONNULL_END
