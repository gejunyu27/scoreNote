//
//  NSString+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSString+SCExtension.h"

@implementation NSString (SCExtension)

- (NSMutableAttributedString *)attributedStringWithLineSpacing:(NSInteger)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

///计算文字高度
- (CGFloat)calculateHeightWithFont:(UIFont *)font width:(CGFloat)width
{
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    
    return height;
    
}

- (CGFloat)calculateHeightWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width
{
    if (!VALID_STRING(self)) {
        return 0;
    }
    
    NSMutableAttributedString *attr = [self attributedStringWithLineSpacing:lineSpacing];
    
    NSDictionary *attributes = [attr attributesAtIndex:0 effectiveRange:NULL];
    NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping]; //计算时要用NSLineBreakByWordWrapping,否则只有一行
    [attr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    CGFloat h = [attr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil].size.height;
    return h;
}

///计算文字宽度
- (CGFloat)calculateWidthWithFont:(UIFont *)font height:(CGFloat)height
{
    CGFloat width = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width;
    
    return width;
}

- (BOOL)isNumber
{
    //移除0-9的数字
    NSString *checkedNumString = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if (checkedNumString.length == 0) {
        return YES;
        
    }else if ([checkedNumString isEqualToString:@"."]) { //看看是否是小数点
        return YES;
        
    }else {
        return NO;
    }
}

//是否是数字，可以有负号
- (BOOL)isNumberAndMinusSign
{
    NSMutableString *str = self.mutableCopy;
    if ([str hasPrefix:@"-"]) { //有负号
        [str deleteCharactersInRange:NSMakeRange(0, 1)]; //移除负号
    }
    
    return [str isNumber];
}

//数组转为json字符串
+ (NSString *)stringFromArray:(NSArray *)array
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return @"";
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonTemp;
}

//字典转为json字符串
+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return @"";
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonTemp;
}

@end
//CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;

