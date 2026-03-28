//
//  ConfigManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
#import "ConfigHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigManager : NSObject

//获取数据
+ (NSArray <ConfigHeaderModel *> *)getConfigHeaderList;
//双平计算
+ (void)doubleDrawCalculate;

//根据类型取值
+ (CGFloat)getValue:(ConfigType)type;

//开发者功能
//是否是验证过的开发者
+ (BOOL)isDeveloper;
+ (BOOL)verifyDeveloperPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
