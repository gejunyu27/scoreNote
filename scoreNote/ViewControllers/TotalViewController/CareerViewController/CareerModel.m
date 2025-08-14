//
//  CareerModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import "CareerModel.h"

@implementation CareerModel

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content tip:(nullable NSString *)tip record:(nullable RecordModel *)record
{
    self = [super init];
    if (self) {
        _title   = title;
        _record  = record;
        _content = content;
        _tip     = tip;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content record:(nullable RecordModel *)record
{
    return [self initWithTitle:title content:content tip:nil record:record];
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content tip:(nullable NSString *)tip
{
    return [self initWithTitle:title content:content tip:tip record:nil];
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    return [self initWithTitle:title content:content tip:nil record:nil];
}

@end
