//
//  BitCoinModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitCoinModel : NSObject <NSSecureCoding>
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) NSDate *date;

@end

NS_ASSUME_NONNULL_END
