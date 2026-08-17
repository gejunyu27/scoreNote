//
//  ConfigModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import "ConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel ()

@end

@implementation ConfigModel
- (instancetype)initWithType:(ConfigType)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self initData];
    }
    return self;
}

#pragma mark -init
- (void)initData
{
    switch (_type) {
        case ConfigTypeLineProfit:
        {
            _title = @"默认每期利润";
            _content = [self getValueContent:_type];
        }
            break;
        case ConfigTypeBaseProfit:
        {
            _title = @"默认固定利润";
            _content = [self getValueContent:_type];
        }
            break;
        case ConfigTypeBreakLine:
        {
            _title = @"默认止损线";
            _content = [self getValueContent:_type];
        }
            break;
        case ConfigTypeIsSporttery:
        {
            _title = @"默认竞彩模式";
            _content = [self getValueContent:_type];
        }
            break;
        case ConfigTypeInputH:
        {
            _title = @"自定义键盘高度";
            _content = [self getValueContent:_type];
        }
            break;
        case ConfigTypeDeveloper:
        {
            _title = @"开发者功能";
        }
            break;
        case ConfigTypeBitCoin:
        {
            _title = @"比特币账本";
        }
            break;
        case ConfigTypeDataBase:
        {
            _title = @"数据备份&清除";
        }
            break;
        case ConfigTypeDataVersion:
        {
            _title = @"数据库版本";
            NSInteger dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_DB_VERSION];
            _content = [NSString stringWithFormat:@"%li",dbVersion+1]; //初始版本是0，显示0不好看，所以展示的时候都比真实版本大1
        }
            break;
        case ConfigTypeAppVersion:
        {
            _title = @"APP版本";
            _content = APP_VERSION;
        }
            break;
        default:
            break;
    }
}

- (NSString *)getValueContent:(ConfigType)type
{
    CGFloat value = [ConfigManager getValue:type];
    NSString *content = [SCUtilities removeFloatSuffix:value];
    return content;
}

#pragma mark -get&set
- (void)setContent:(NSString *)content
{
    _content = content;
    
    CGFloat value = content.floatValue;
    
    [ConfigManager setValue:value type:_type];
}

@end

NS_ASSUME_NONNULL_END
