//
//  ConfigHeaderModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import "ConfigHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ConfigHeaderModel

- (instancetype)initWithType:(ConfigHeaderType)type list:(nonnull NSArray<ConfigModel *> *)list
{
    self = [super init];
    if (self) {
        _type = type;
        _list = list;
        [self initTitle];

    }
    return self;
}

- (void)initTitle
{
    switch (_type) {
        case ConfigHeaderTypeCalcalte:
            _title = @"双平计算";
            break;
        case ConfigHeaderTypeCommon:
            _title = @"常用设置";
            break;
        case ConfigHeaderTypeFuction:
            _title = @"其它功能";
            break;
            
        default:
            break;
    }
}

@end

NS_ASSUME_NONNULL_END
