//
//  ConfigSectionModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/4.
//

#import "ConfigSectionModel.h"

@implementation ConfigSectionModel

- (NSMutableArray<ConfigModel *> *)models
{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
