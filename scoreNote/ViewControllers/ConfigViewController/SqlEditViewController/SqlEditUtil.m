//
//  SqlEditUtil.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import "SqlEditUtil.h"

#define kSEYMD    @"yyyy-MM-dd"
#define kSEYMDHM  @"yyyy-MM-dd HH:mm"

@implementation SqlEditUtil

+ (NSString *)getDateString:(NSDate *)date prefix:(NSString *)prefix placeholder:(nullable NSString *)placeholder
{
    NSString *prefixStr = VALID_STRING(prefix) ? [NSString stringWithFormat:@"%@：", prefix] : @"";
    
    NSString *dateStr;
    if (date) {
        dateStr = [date getStringWithDateFormat:kSEYMDHM];
        
    }else {
        dateStr = placeholder ? placeholder : @"无";
    }
    
    NSString *string = [NSString stringWithFormat:@"%@%@", prefixStr, dateStr];

    return string;
}

+ (NSDate *)getEditDate:(NSString *)string
{
    NSString *datefomat = [string containsString:@" "] ? kSEYMDHM : kSEYMD;
    NSDate *date = [NSDate getDateWithString:string dateFormat:datefomat];
    return date;
}

@end
