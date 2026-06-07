//
//  BitCoinModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitCoinModel : NSObject <NSSecureCoding>
@property (nonatomic, assign) BOOL isRecharge;  //是否是存储
@property (nonatomic, copy) NSString *money;    //金额
@property (nonatomic, strong) NSDate *date;     //日期

@end

NS_ASSUME_NONNULL_END
