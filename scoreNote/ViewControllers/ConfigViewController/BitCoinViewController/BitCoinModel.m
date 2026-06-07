//
//  BitCoinModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/5/25.
//

#import "BitCoinModel.h"

#define kMoney      @"money"
#define kDate       @"date"
#define kIsRecharge @"isRecharge"

@implementation BitCoinModel

+ (BOOL)supportsSecureCoding {
    return YES;
}

//存储
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.money forKey:kMoney];
    [coder encodeObject:self.date forKey:kDate];
    [coder encodeObject:@(self.isRecharge) forKey:kIsRecharge];
}

//取出
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _money      = [coder decodeObjectForKey:kMoney];
        _date       = [coder decodeObjectForKey:kDate];
        _isRecharge = [(NSNumber *)[coder decodeObjectForKey:kIsRecharge] integerValue];
    }
    return self;
}

@end
