//
//  ConfigHeaderModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/27.
//

#import "ConfigHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigHeaderModel ()
@end

@interface ConfigModel ()
- (void)setDefaultHeaderType:(ConfigHeaderType)headerType;
@end

@implementation ConfigHeaderModel
- (void)setType:(ConfigHeaderType)type
{
    _type = type;
    
    NSInteger num = 0;
    //名称
    switch (type) {
        case ConfigHeaderTypeCalculate:
            _name = @"双平计算";
            num = 1;
            break;
        case ConfigHeaderTypeCommon:
            _name = @"常用设置";
            num = 4;
            break;
        case ConfigHeaderTypeWeb:
            _name = @"嵌入网页设置";
            num = 2;
            break;
        case ConfigHeaderTypeOther:
            _name = @"其它";
            num = 4;
            break;
            
        default:
            break;
    }
    
    //2.获取列表
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:num];
    for (int i=0; i<num; i++) {
        ConfigModel *model = [ConfigModel new];
        [model setDefaultHeaderType:type];
        [temp addObject:model];
    }
    
    _configList = [temp copy];
    
    _isOn = YES;
    
}

@end



@implementation ConfigModel
- (void)setDefaultHeaderType:(ConfigHeaderType)headerType
{
    _headerType = headerType;
}


@end

NS_ASSUME_NONNULL_END
