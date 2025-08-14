//
//  NSString+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SCExtension)

///添加行间距
- (NSMutableAttributedString *)attributedStringWithLineSpacing:(NSInteger)lineSpacing;

///计算文字高度
- (CGFloat)calculateHeightWithFont:(UIFont *)font width:(CGFloat)width;
- (CGFloat)calculateHeightWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width;

///计算文字宽度
- (CGFloat)calculateWidthWithFont:(UIFont *)font height:(CGFloat)height;

//是否是数字（包含小数，无负号）
- (BOOL)isNumber;

//是否是数字，可以有负号
- (BOOL)isNumberAndMinusSign;

//数组转为json字符串
+ (NSString *)stringFromArray:(NSArray *)array;
//字典转为json字符串
+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
