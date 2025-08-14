//
//  SCUtilities.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef   VALID_DICTIONARY
#define  VALID_DICTIONARY(P)   [SCUtilities isValidDictionary:P]

#undef   VALID_ARRAY
#define  VALID_ARRAY(P)        [SCUtilities isValidArray:P]

#undef   VALID_STRING
#define  VALID_STRING(P)       [SCUtilities isValidString:P]

#undef   VALID_DATA
#define  VALID_DATA(P)         [SCUtilities isValidData:P]

NS_ASSUME_NONNULL_BEGIN

@interface SCUtilities : NSObject

//! 是否是有效的字典
+ (BOOL)isValidDictionary:(id)object;
//! 是否是有效的数组
+ (BOOL)isValidArray:(id)object;
//! 是否是有效的字符串
+ (BOOL)isValidString:(id)object;
//! 是否是有效的内存二进制数据
+ (BOOL)isValidData:(id)object;

//移除小数点
+ (NSString *)removeFloatSuffix:(CGFloat)number;

//获取vc
+ (UITabBarController *)currentTabBarController;
+ (UINavigationController *)currentNavigationController;
+ (UIViewController *)currentViewController;


//常用弹窗
+ (void)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message textFieldBlock:(nullable void (^)(UITextField *textField))textFieldBlock sureBlock:(nullable void (^)(NSString * _Nullable text))sureBlock;

//获取中文拼音首字母
+ (NSString *)getPinyinFirstCharFromString:(NSString *)string;

//DES加密
+ (NSString *)desEncrypt:(NSString *)text;

//DES解密
+ (NSString *)desDecrypt:(NSString *)text;

@end 

NS_ASSUME_NONNULL_END
