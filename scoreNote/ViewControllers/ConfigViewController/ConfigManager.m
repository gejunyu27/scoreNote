//
//  ConfigManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

static CGFloat kInputH;  //键盘高度取的比较频繁，就保存在内存中，不每次从本地取

#import "ConfigManager.h"
@interface ConfigManager ()
@property (nonatomic, assign) BOOL isDeveloper;
@property (nonatomic, copy) NSString *developerPassword;

@end

@implementation ConfigManager


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark -public method
//根据类型取值
+ (CGFloat)getValue:(ConfigType)type
{
    BOOL isInput = type == ConfigTypeInputH;
    if (isInput && kInputH > 0) { //键盘高度取用频繁，节省性能（虽然也浪费不了多少）
        return kInputH;
    }
    
    NSString *cacheKey = [self getCacheKey:type];
    if (cacheKey.length == 0) {
        return 0;
    }
    
    //先判断本地是否已经存储
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL hasCache = [userDefaults objectForKey:cacheKey]; //没有返回nil说明已经在本地存过
    
    CGFloat value = 0;
    
    if (hasCache) { //存储过，直接本地取值
        value = [userDefaults floatForKey:cacheKey];
        
    }else { //没存储过， 赋默认值，并存储本地
        value = [self getDefaultValue:type];
        [self setValue:value type:type];
    }
    
    if (isInput) {
        kInputH = value;
    }
    
    return value;
}

//根据类型赋值
+ (void)setValue:(CGFloat)value type:(ConfigType)type
{
    NSString *cacheKey = [self getCacheKey:type];
    
    if (cacheKey.length > 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:cacheKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (type == ConfigTypeInputH) {
            kInputH = value;
        }
    }
    
}

+ (NSString *)getCacheKey:(ConfigType)type
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
        case ConfigTypeIsSporttery:
            propertyName = @"isSporttery";
            break;
        case ConfigTypeInputH:
            propertyName = @"inputH";
            break;
            
        default:
            return @"";
    }

    NSString *key = [NSString stringWithFormat:@"key_%@", propertyName];
    
    return key;
}

//重置数值
+ (CGFloat)getDefaultValue:(ConfigType)type
{
    CGFloat value = 0;
    switch (type) {
        case ConfigTypeLineProfit:
            value = 50;
            break;
        case ConfigTypeBaseProfit:
            value = 0;
            break;
        case ConfigTypeBreakLine:
            value = 5000;
            break;
        case ConfigTypeIsSporttery:
            value = 1;
            break;
        case ConfigTypeInputH:
            value = (IS_BANGS_SCREEN ? 300 : 245);
            break;

        default:
            break;
    }
    
    return value;
}

@end
