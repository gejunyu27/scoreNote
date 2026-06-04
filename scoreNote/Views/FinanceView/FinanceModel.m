//
//  FinanceModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import "FinanceModel.h"

@implementation FinanceModel

- (instancetype)initWithTitle:(NSString *)title content:(nonnull NSString *)content
{
    self = [super init];
    if (self) {
        _title   = title;
        _content = content;
    }
    return self;
}

@end
