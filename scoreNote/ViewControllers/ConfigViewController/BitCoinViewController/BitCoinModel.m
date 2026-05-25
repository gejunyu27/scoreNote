//
//  BitCoinModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/5/25.
//

#import "BitCoinModel.h"

#define kMoney @"money"
#define kDate  @"date"

@implementation BitCoinModel

+ (BOOL)supportsSecureCoding {
    return YES;
}

//存储
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.money forKey:kMoney];
    [coder encodeObject:self.date forKey:kDate];
}

//取出
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _money = [coder decodeObjectForKey:kMoney];
        _date  = [coder decodeObjectForKey:kDate];
    }
    return self;
}

@end
