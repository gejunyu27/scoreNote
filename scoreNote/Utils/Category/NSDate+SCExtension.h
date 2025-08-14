//
//  NSDate+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SCExtension)

//比较两个日期相差的月数
- (NSInteger)monthsBetweenDate:(NSDate *)toDate;

//是否是当月
- (BOOL)isCurrentMonth;

//比较两个日期相差的天数 但判断是否同一天最好用isToday,因为这个方法判断是否同一天用得是否是24h，比如 23点和明天1点，相差时长不足24h得出结果会是相差0天
- (NSInteger)daysBetweenDate:(NSDate *)toDate;

//是否是同一天
- (BOOL)isSameDay:(NSDate *)anotherDate;

//是否是今天
- (BOOL)isToday;

//是否是同一周
- (BOOL)isSameWeek:(NSDate *)anotherDate;

//是否是本周
- (BOOL)isCurrentWeek;

//是否是同一年
- (BOOL)isSameYear:(NSDate *)anotherDate;

//是否是今年
- (BOOL)isCurrentYear;

//获取指定日期
+ (NSDate *)getDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)getDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

//根据制定格式获取时间
+ (nullable NSDate *)getDateWithString:(NSString *)string dateFormat:(NSString *)dateFormat;
- (NSString *)getStringWithDateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
