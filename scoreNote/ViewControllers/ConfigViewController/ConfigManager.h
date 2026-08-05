//
//  ConfigManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ConfigType) {
    //数值设置
    ConfigTypeLineProfit,    //每期利润
    ConfigTypeBaseProfit,    //固定利润
    ConfigTypeBreakLine,     //止损线
    ConfigTypeIsSporttery,   //是否是竞彩模式
    
    //常用功能
    ConfigTypeInputH,        //自定义键盘高度
    ConfigTypeDeveloper,     //开发者功能
    ConfigTypeBitCoin,       //比特币
    ConfigTypeDoubleDraw,    //双平计算
    
    //系统 (以后如果联网会增加联系我们，求助反馈等功能)
    ConfigTypeSaveData,      //备份数据
    ConfigTypeClearData,     //清除数据
    ConfigTypeDataVersion,   //数据库版本
    ConfigTypeAppVersion,    //APP版本
    
};

@interface ConfigManager : NSObject

//根据类型取值
+ (CGFloat)getValue:(ConfigType)type;
//根据类型赋值
+ (void)setValue:(CGFloat)value type:(ConfigType)type;

@end

NS_ASSUME_NONNULL_END
