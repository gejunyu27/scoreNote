//
//  ConfigHeaderModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/27.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConfigHeaderType) {
    ConfigHeaderTypeCalculate,     //双平计算
    ConfigHeaderTypeCommon,        //常用设置
    ConfigHeaderTypeWeb,           //嵌入式网页设置
    ConfigHeaderTypeOther          //其它
};

NS_ASSUME_NONNULL_BEGIN
@class ConfigModel;

@interface ConfigHeaderModel : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign) ConfigHeaderType type;
@property (nonatomic ,strong, readonly) NSArray <ConfigModel *> *configList;
@property (nonatomic, assign) BOOL isOn; //是否展开

@end


@interface ConfigModel : NSObject
@property (nonatomic, assign, readonly) ConfigHeaderType headerType; //父类属性


@end

NS_ASSUME_NONNULL_END
