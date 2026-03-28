//
//  ConfigManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "ConfigManager.h"
#import "ConfigHeaderModel.h"

@interface ConfigManager ()
//1双平计算
//2常用设置设置
@property (nonatomic, assign) CGFloat lineProfit;   //每期利润
@property (nonatomic, assign) CGFloat baseProfit;   //固定利润
@property (nonatomic, assign) CGFloat breakLine;    //止损线
@property (nonatomic, assign) CGFloat inputH;       //自定义键盘高度
@property (nonatomic, assign) BOOL isCasino;        //是否是外围
//3.嵌入式网页设置
@property (nonatomic, assign) CGFloat orderListH;   //订单高度
@property (nonatomic, assign) CGFloat orderWebH;    //网页高度
//4.其它
@end

@implementation ConfigManager
DEF_SINGLETON(ConfigManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaultData];
    }
    return self;
}

- (void)setupDefaultData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //每期利润
    NSString *lineProfitKey = [self keyForType:ConfigTypeLineProfit];
    if ([userDefaults objectForKey:lineProfitKey]) { //先判断有没有存过
        //有存过，直接赋值
        _lineProfit = [userDefaults floatForKey:lineProfitKey];
    }else {
        //从未存过
        [self setValue:50 type:ConfigTypeLineProfit];
    }
    
    //固定利润
    NSString *baseProfitKey = [self keyForType:ConfigTypeBaseProfit];
    if ([userDefaults objectForKey:baseProfitKey]) {
        _baseProfit = [userDefaults floatForKey:baseProfitKey];
    }else {
        [self setValue:0 type:ConfigTypeBaseProfit];
    }
    
    //止损线
    NSString *breakLineKey = [self keyForType:ConfigTypeBreakLine];
    if ([userDefaults objectForKey:breakLineKey]) {
        _breakLine = [userDefaults floatForKey:breakLineKey];
    }else {
        [self setValue:5000 type:ConfigTypeBreakLine];
    }
    
    //自定义键盘高度
    NSString *inputHKey = [self keyForType:ConfigTypeInputH];
    if ([userDefaults objectForKey:inputHKey]) {
        _inputH = [userDefaults floatForKey:inputHKey];
    }else {
        [self setValue:320 type:ConfigTypeInputH];
    }
    
    //订单高度
    NSString *orderListHKey = [self keyForType:ConfigTypeOrderListH];
    if ([userDefaults objectForKey:orderListHKey]) {
        _orderListH = [userDefaults floatForKey:orderListHKey];
    }else {
        [self setValue:300 type:ConfigTypeOrderListH];
    }
    
    //网页高度
    NSString *orderWebHKey = [self keyForType:ConfigTypeOrderWebH];
    if ([userDefaults objectForKey:orderWebHKey]) {
        _orderWebH = [userDefaults floatForKey:orderWebHKey];
    }else {
        [self setValue:500 type:ConfigTypeOrderWebH];
    }
    
    //是否是外围
    NSString *isCasinoKey = [self keyForType:ConfigTypeIsCasino];
    if ([userDefaults objectForKey:isCasinoKey]) {
        _isCasino = ([userDefaults floatForKey:isCasinoKey]!=0 ? YES : NO);
        
    }else {
        [self setValue:1 type:ConfigTypeIsCasino];
    }
    
}

- (NSString *)keyForType:(ConfigType)type
{
    NSString *propertyName = @"";
    
    switch (type) {
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
        case ConfigTypeIsCasino:
            propertyName = @"isCasino";
            break;
        case ConfigTypeOrderListH:
            propertyName = @"orderListH";
            break;
        case ConfigTypeOrderWebH:
            propertyName = @"orderWebH";
            break;
            
        default:
            return @"";
    }
    
    NSString *key = [NSString stringWithFormat:@"key_%@", propertyName];
    
    return key;
}



#pragma mark -get&set
//根据类型赋值
+ (void)setValue:(CGFloat)value type:(ConfigType)type
{
    [[self sharedInstance] setValue:value type:type];
}
- (void)setValue:(CGFloat)value type:(ConfigType)type
{
    //赋值
    switch (type) {
        case ConfigTypeLineProfit:
            _lineProfit = value;
            break;
        case ConfigTypeBaseProfit:
            _baseProfit = value;
            break;
        case ConfigTypeBreakLine:
            _breakLine = value;
            break;
        case ConfigTypeInputH:
            _inputH = value;
            break;
        case ConfigTypeIsCasino:
            _isCasino = (value != 0 ? YES : NO);
            break;
        case ConfigTypeOrderListH:
            _orderListH = value;
            break;
        case ConfigTypeOrderWebH:
            _orderWebH = value;
            break;
            
        default:
            return;
    }
    
    //储存本地
    NSString *key = [self keyForType:type];
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//根据类型取值
+ (CGFloat)getValue:(ConfigType)type
{
    return [[self sharedInstance] getValue:type];
}

- (CGFloat)getValue:(ConfigType)type
{
    switch (type) {
        case ConfigTypeLineProfit:
            return _lineProfit;
        case ConfigTypeBaseProfit:
            return _baseProfit;
        case ConfigTypeBreakLine:
            return _breakLine;
        case ConfigTypeInputH:
            return _inputH ;
        case ConfigTypeIsCasino:
            return _isCasino;
        case ConfigTypeOrderListH:
            return _orderListH ;
        case ConfigTypeOrderWebH:
            return _orderWebH;
            
        default:
            return 0;
    }
}

//获取配置列表
+ (NSArray <ConfigHeaderModel *> *)getConfigHeaderModels
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:6];
    
    for (NSInteger i = ConfigHeaderTypeCalculate; i <= ConfigHeaderTypeOther; i++) {
        ConfigHeaderType headerType = i;
        ConfigHeaderModel *headerModel = [ConfigHeaderModel new];
        headerModel.type = headerType;
        [temp addObject:headerModel];
    }
    
    return [temp copy];
}
@end
