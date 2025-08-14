//
//  NSDate+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSDate+SCExtension.h"

@implementation NSDate (SCExtension)

- (NSInteger)monthsBetweenDate:(NSDate *)toDate
{
    //该方法 如果不足月则不按1个月算， 比如 计算2023.2.2 和 2023.3.1 会得出相差0个月
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:toDate options:NSCalendarWrapComponents];
//
//    NSInteger months = [components month];
//
//    return labs(months);
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSInteger selfYear = [cal component:NSCalendarUnitYear fromDate:self];
    NSInteger selfMonth = [cal component:NSCalendarUnitMonth fromDate:self];
    
    NSInteger toYear = [cal component:NSCalendarUnitYear fromDate:toDate];
    NSInteger toMonth = [cal component:NSCalendarUnitMonth fromDate:toDate];
    
    
    NSInteger months = (toYear - selfYear)*12 + (toMonth - selfMonth);
    
    return labs(months);
    
}

//是否是当月
- (BOOL)isCurrentMonth
{
    NSInteger months = [self monthsBetweenDate:[NSDate date]];
    
    return months <= 0;
}

- (NSInteger)daysBetweenDate:(NSDate *)toDate
{
    
    NSTimeInterval time = [self timeIntervalSinceDate:toDate];
    
    NSInteger days = abs((int)(time / 60.0 / 60.0 / 24.0));
    
    if (days > 0) {
        return days;
        
    }else { //上面方法是用是否超过24h判断，0有可能是错误结果，需要再验证一次
        NSString *selfDay = [self getStringWithDateFormat:@"dd"];
        NSString *toDay   = [toDate getStringWithDateFormat:@"dd"];
        
        return [selfDay isEqualToString:toDay] ? 0 : 1;
    }

}

- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

- (BOOL)isSameDay:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
    
    return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}


//是否是同一周
- (BOOL)isSameWeek:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 1; //一周开始默认为星期天 不设置会默认为星期天
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitWeekOfYear;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:anotherDate];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:self];
    return (([comp1 year] == [comp2 year]) && ([comp1 weekOfYear] == [comp2 weekOfYear]));
}

//是否是本周
- (BOOL)isCurrentWeek
{
    return [self isSameWeek:[NSDate date]];
}


//是否是同一年
- (BOOL)isSameYear:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:anotherDate];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:self];
    return ([comp1 year] == [comp2 year]);
}

//是否是今年
- (BOOL)isCurrentYear
{
    return [self isSameYear:[NSDate date]];
}

//获取指定日期
+ (NSDate *)getDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents *comp = [NSDateComponents new];
    [comp setMonth:month];
    [comp setDay:day];
    [comp setYear:year];
    [comp setHour:hour];
    [comp setMinute:minute];
    [comp setSecond:second];
    
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *newDay = [myCal dateFromComponents:comp];

    return newDay;
}

+ (NSDate *)getDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    return [self getDateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

//根据制定格式获取时间
- (NSString *)getStringWithDateFormat:(NSString *)dateFormat;
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = dateFormat;
    
    NSString *dateStr = [df stringFromDate:self];
    
    return dateStr;
}

+ (nullable NSDate *)getDateWithString:(NSString *)string dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = dateFormat;
    
    NSDate *strDate = [df dateFromString:string];
    
    return strDate;
}

@end
