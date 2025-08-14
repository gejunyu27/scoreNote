//
//  SCUtilities.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCUtilities.h"
#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonCrypto.h>

#define kDESKEY @"&jah%*"

@interface SCUtilities ()
AS_SINGLETON(SCUtilities)

@end

@implementation SCUtilities
DEF_SINGLETON(SCUtilities)


+ (BOOL)isValidDictionary:(id)object
{
    return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
    
}

+ (BOOL)isValidArray:(id)object
{
    return object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count;
}

+ (BOOL)isValidString:(id)object
{
    return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

+ (BOOL)isValidData:(id)object
{
    return object && [object isKindOfClass:[NSData class]] && ((NSData *)object).length;
}


+ (NSString *)removeFloatSuffix:(CGFloat)number
{
    NSString *numberStr = NSStringFormat(@"%.2f",number);
    if (numberStr.length > 1) {
        
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return @"0";
    }
}

//获取vc
+ (UITabBarController *)currentTabBarController
{
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    return [vc isKindOfClass:UITabBarController.class] ? (UITabBarController *)vc : nil;
}

+ (UINavigationController *)currentNavigationController
{
    UITabBarController *tabBarVc = [SCUtilities currentTabBarController];
    if (!tabBarVc) {
        return nil;
    }
    
    NSInteger currentIndex = tabBarVc.selectedIndex;
    UIViewController *vc = tabBarVc.viewControllers[currentIndex];

    return [vc isKindOfClass:UINavigationController.class] ? (UINavigationController *)vc : nil;
}

+ (UIViewController *)currentViewController
{
    UITabBarController *tabBarVc = [SCUtilities currentTabBarController];
    if (!tabBarVc) {
        return nil;
    }
    
    NSInteger currentIndex = tabBarVc.selectedIndex;
    
    UIViewController *vc = tabBarVc.viewControllers[currentIndex];
    
    if ([vc isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController *) vc).topViewController;
        
    }else {
        return vc;
    }
}

//常用弹窗
+ (void)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message textFieldBlock:(void (^)(UITextField *textField))textFieldBlock sureBlock:(nullable void (^)(NSString * _Nullable))sureBlock
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (textFieldBlock) {
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFieldBlock(textField);
        }];
    }
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text;
        if (textFieldBlock) {
            UITextField *outTextField = ac.textFields.firstObject;
            text = outTextField.text;
        }
        
        if (sureBlock) {
            sureBlock(text);
        }
    }]];
    
    [[self currentViewController] presentViewController:ac animated:YES completion:nil];
}

//获取中文拼音首字母
+ (NSString *)getPinyinFirstCharFromString:(NSString *)string
{
    NSMutableString *mulstr = string.mutableCopy;
    CFStringTransform((__bridge CFMutableStringRef)mulstr, NULL, kCFStringTransformToLatin, NO);
    
//    NSMutableString *firstCharJoin = [NSMutableString new];
//    NSArray <NSString *> *pinyinArr = [mulstr componentsSeparatedByString:@" "];
//    for (NSString *str in pinyinArr) {
//        [firstCharJoin appendFormat:@"%c",[str characterAtIndex:0]];
//    }
    NSArray <NSString *> *pinyinArr = [mulstr componentsSeparatedByString:@" "];
    NSString *firstCharJoin = [NSString stringWithFormat:@"%c", [pinyinArr.firstObject characterAtIndex:0]]; 
    
    return firstCharJoin.uppercaseString;
}

//des加密
+ (NSString *)desEncrypt:(NSString *)text
{
    Byte digits[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
    NSString *result = nil;
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger bufferSize = ([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    char buffer[bufferSize];
    memset (buffer, 0, sizeof (buffer));
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus =
    CCCrypt (kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [kDESKEY UTF8String], kCCKeySizeDES,
             digits, [data bytes], [data length], buffer, bufferSize, &bufferNumBytes);
    if (cryptStatus == kCCSuccess) {
        result = [self dataToHex:[NSData dataWithBytes:buffer length:bufferNumBytes]];
    }
    return result;
}

//NSData转化为16进制字符串
+ (NSString*)dataToHex:(NSData*)data
{
    NSMutableString *s = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    for (int i=0; i<data.length; i++) {
        NSString *ts = [NSString stringWithFormat:@"%02x",bytes[i]];
        [s appendString:ts];
    }
    return s;
}

//DES解密
+ (NSString *)desDecrypt:(NSString *)text
{
    Byte digits[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
    NSData *data = [self hexToData:(text?:@"")];
    
    NSUInteger bufferSize = ([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    uint8_t *buffer = malloc(bufferSize * sizeof(uint8_t));
    memset ((void *)buffer, 0, sizeof (buffer));
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus =
    CCCrypt (kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [kDESKEY UTF8String], kCCKeySizeDES,
             digits, [data bytes], [data length], buffer, bufferSize, &bufferNumBytes);
    
    NSString *result = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *plainData = [NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
        result = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return result;
}

//16进制字符串转化为NSData
+ (NSData *)hexToData:(NSString*)hexString
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= [hexString length]; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


@end
