//
//  ConfigModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import "ConfigModel.h"
#import "ConfigHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel ()
@property (nonatomic, copy, readonly) NSString *cacheKey;
@end

@implementation ConfigModel
#pragma mark -双平计算
- (instancetype)initWithCalculateType:(ConfigCalculate)calculateType
{
    self = [super init];
    if (self) {
        _calculateType = calculateType;
        _point         = @"";
        _pay           = @"";
        [self initCalcuteTitle];
    }
    return self;
}

- (void)initCalcuteTitle
{
    switch (_calculateType) {
        case ConfigCalculateTarget:
            _title = @"目标";
            break;
        case ConfigCalculateFirst:
            _title = @"赔率1";
            break;
        case ConfigCalculateSecond:
            _title = @"赔率2";
            break;
            
        default:
            break;
    }
}

#pragma mark -常用设置
- (instancetype)initWithConfigType:(ConfigType)configType
{
    self = [super init];
    if (self) {
        _configType = configType;
        _cacheKey   = [self getCacheKey];
        
        [self initValue];
        [self initConfigTitle];
    }
    return self;
}

- (void)initValue
{
    //先判断本地是否已经存储
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL hasCache = [userDefaults objectForKey:_cacheKey]; //没有返回nil说明已经在本地存过
    
    if (hasCache) { //存储过，直接本地取值
        _value = [userDefaults floatForKey:_cacheKey];
        
    }else { //没存储过， 赋默认值，并存储本地
        [self resetValue];
    }
    
}

- (NSString *)getCacheKey
{
    NSString *propertyName = @"";
    
    switch (_configType) {
        case ConfigTypeLineProfit:
            propertyName = @"lineProfit";
            break;
        case ConfigTypeBaseProfit:
            propertyName = @"baseProfit";
            break;
        case ConfigTypeBreakLine:
            propertyName = @"breakLine";
            break;
        case ConfigTypeInputH:
            propertyName = @"inputH";
            break;
        case ConfigTypeOrderListH:
            propertyName = @"orderListH";
            break;
        case ConfigTypeOrderWebH:
            propertyName = @"orderWebH";
            break;
        case ConfigTypeIsCasino:
            propertyName = @"isCasino";
            break;
            
        default:
            return @"";
    }

    NSString *key = [NSString stringWithFormat:@"key_%@", propertyName];
    
    return key;
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:_cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//重置数值
- (void)resetValue
{
    switch (_configType) {
        case ConfigTypeLineProfit:
            self.value = 50;
            break;
        case ConfigTypeBaseProfit:
            self.value = 0;
            break;
        case ConfigTypeBreakLine:
            self.value = 5000;
            break;
        case ConfigTypeInputH:
            self.value = 300;
            break;
        case ConfigTypeOrderListH:
            self.value = 390;
            break;
        case ConfigTypeOrderWebH:
            self.value = 600;
            break;
        case ConfigTypeIsCasino:
            self.value = 1;
            break;
        default:
            break;
    }
}

- (void)initConfigTitle
{
    switch (_configType) {
        case ConfigTypeLineProfit:
            _title = @"默认每期利润";
            break;
        case ConfigTypeBaseProfit:
            _title = @"默认固定利润";
            break;
        case ConfigTypeBreakLine:
            _title = @"默认止损线";
            break;
        case ConfigTypeInputH:
            _title = @"自定义键盘高度";
            break;
        case ConfigTypeOrderListH:
            _title = @"嵌网模式订单高度";
            break;
        case ConfigTypeOrderWebH:
            _title = @"嵌网模式网页高度";
            break;
        case ConfigTypeIsCasino:
            _title = @"默认外围模式";
            break;
            
        default:
            break;
    }
}


#pragma mark -其它功能
- (instancetype)initWithFunctionType:(ConfigFunction)functionType
{
    self = [super init];
    if (self) {
        _functionType = functionType;
        [self initFunctionTitles];
    }
    return self;
}

- (void)initFunctionTitles
{
    switch (_functionType) {
        case ConfigFunctionBitAndDeveloper:
            _title = @"开发者选项";
            _secondTitle = @"比特币账本";
            break;
            
        case ConfigFunctionData:
            _title = @"备份数据库";
            _secondTitle = @"删除数据库";
            break;
            
        default:
            break;
    }
}

@end

NS_ASSUME_NONNULL_END
