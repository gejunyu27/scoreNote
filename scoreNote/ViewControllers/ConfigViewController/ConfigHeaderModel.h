//
//  ConfigHeaderModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"

typedef NS_ENUM(NSInteger, ConfigHeaderType) {
    ConfigHeaderTypeCalcalte,   //双平计算
    ConfigHeaderTypeCommon,     //常用设置
    ConfigHeaderTypeFuction,    //其它功能
    ConfigHeaderTypeCount       //计数用  无实际意义 必须放最后一个
};

NS_ASSUME_NONNULL_BEGIN

@interface ConfigHeaderModel : NSObject
@property (nonatomic, assign, readonly) ConfigHeaderType type;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSArray <ConfigModel *> *list;

- (instancetype)initWithType:(ConfigHeaderType)type list:(NSArray <ConfigModel *> *)list;

@end

NS_ASSUME_NONNULL_END
