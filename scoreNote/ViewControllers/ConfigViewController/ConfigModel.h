//
//  ConfigModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
//@class ConfigHeaderModel;

typedef NS_ENUM(NSInteger, ConfigCalculate) {
    ConfigCalculateTarget,
    ConfigCalculateFirst,
    ConfigCalculateSecond,
    ConfigCalculateCount     //计数用  无实际意义 必须放最后一个
};

typedef NS_ENUM(NSInteger, ConfigType) {
    ConfigTypeLineProfit,  //每期利润
    ConfigTypeBaseProfit,  //固定利润
    ConfigTypeBreakLine,   //止损线
    ConfigTypeInputH,      //自定义键盘高度
    ConfigTypeOrderListH,  //网页嵌入模式下订单高度
    ConfigTypeOrderWebH,   //网页嵌入模式下网页高度
    ConfigTypeIsCasino,    //是否是外围
    ConfigTypeCount        //计数用  无实际意义 必须放最后一个
};

typedef NS_ENUM(NSInteger, ConfigFunction) {
    ConfigFunctionBitAndDeveloper,     //比特币账本+开发者选项
    ConfigFunctionData,                //备份数据库+删除数据库
    ConfigFunctionCount                //计数用  无实际意义 必须放最后一个
};


NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject
//通用属性
@property (nonatomic, copy, readonly) NSString *title;

//双平计算属性
@property (nonatomic, assign, readonly) ConfigCalculate calculateType;   //计算类型
@property (nonatomic, copy) NSString *point;                   //赔率
@property (nonatomic, copy) NSString *pay;                     //投入


//常用设置属性
@property (nonatomic, assign, readonly) ConfigType configType;   //设置属性
@property (nonatomic, assign) CGFloat value;                     //数值

//其它功能属性
@property (nonatomic, assign, readonly) ConfigFunction functionType;   //功能属性
@property (nonatomic, copy, readonly) NSString *secondTitle; //第二个按钮名称

- (instancetype)initWithCalculateType:(ConfigCalculate)calculateType;
- (instancetype)initWithConfigType:(ConfigType)configType;
- (instancetype)initWithFunctionType:(ConfigFunction)functionType;

- (void)resetValue; //重置数值
@end

NS_ASSUME_NONNULL_END
