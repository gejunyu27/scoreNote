//
//  ColumnManager.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/6.
//

#import <Foundation/Foundation.h>
#import "ColumnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColumnManager : NSObject

//更新数据库
+ (void)updateColumns;

//开发者功能 
//新增字段
+ (BOOL)addNewColumnWithName:(NSString *)name type:(NSString *)type notnull:(BOOL)notnull table:(NSString *)table;
//获取所有字段
+ (NSArray < ColumnModel *>*)queryAllColumnsFromTable:(NSString *)table;

@end

NS_ASSUME_NONNULL_END
