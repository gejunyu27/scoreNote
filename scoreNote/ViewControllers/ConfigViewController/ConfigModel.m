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

#pragma mark -get&set
- (void)setType:(ConfigType)type
{
    _type = type;
    
    switch (type) {
        case ConfigTypeLineProfit:
        {
            _title = @"默认每期利润";
            _content = [self getValueContent:type];
        }
            break;
        case ConfigTypeBaseProfit:
        {
            _title = @"默认固定利润";
            _content = [self getValueContent:type];
        }
            break;
        case ConfigTypeBreakLine:
        {
            _title = @"默认止损线";
            _content = [self getValueContent:type];
        }
            break;
        case ConfigTypeIsSporttery:
        {
            _title = @"默认竞彩模式";
            _content = [self getValueContent:type];
        }
            break;
        case ConfigTypeInputH:
        {
            _title = @"自定义键盘高度";
            _content = [self getValueContent:type];
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
        case ConfigTypeDoubleDraw:
        {
            _title = @"双平计算";
        }
            break;
        case ConfigTypeSaveData:
        {
            _title = @"备份数据";
        }
            break;

        case ConfigTypeClearData:
        {
            _title = @"清除数据";
        }
            break;
        case ConfigTypeDataVersion:
        {
            _title = @"数据库版本";
            _content = [NSString stringWithFormat:@"%li",[[NSUserDefaults standardUserDefaults] integerForKey:KEY_DB_VERSION]];
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

- (void)setContent:(NSString *)content
{
    _content = content;
    
    CGFloat value = content.floatValue;
    
    [ConfigManager setValue:value type:_type];
}

@end

NS_ASSUME_NONNULL_END
