//
//  SqlEditUtil.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SqlEditUtil : NSObject

+ (NSString *)getDateString:(NSDate *)date prefix:(nullable NSString *)prefix placeholder:(nullable NSString *)placeholder;

+ (NSDate *)getEditDate:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
