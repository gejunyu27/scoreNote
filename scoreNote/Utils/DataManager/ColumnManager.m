//
//  ColumnManager.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/6.
//

#import "ColumnManager.h"
#import "DataManager.h"
#import <FMDB.h>

@interface ColumnManager ()
@end

@implementation ColumnManager

+ (void)updateColumns
{
    NSInteger newestVersion = 0;
    
    NSInteger currentVersion = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_DB_VERSION];
    
    //最新版本,无需更新
    if (newestVersion <= currentVersion) {
        return;
    }
    
    //版本落后
    //1.获取最新字段
    NSArray *recordColumns = [self getNewestRecordColumns];
    NSArray *lineColumns   = [self getNewestLinesColumns];
    NSArray *tagColumns    = [self getNewestTagsColumns];
    
    //2.更新字段
    BOOL recordSuccess = [self addColumns:recordColumns table:[DataManager recordTableName]];
    BOOL lineSuccess   = [self addColumns:lineColumns table:[DataManager lineTableName]];
    BOOL tagSuccess    = [self addColumns:tagColumns table:[DataManager tagTableName]];
    
    if (recordSuccess && lineSuccess && tagSuccess) {
        [[NSUserDefaults standardUserDefaults] setInteger:newestVersion forKey:KEY_DB_VERSION];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else {
        [self showWithStatus:@"数据库更新失败"];
    }
}

#pragma mark -获取最新字段
+ (NSArray <ColumnModel *>*)getNewestRecordColumns
{
    NSArray *models = @[
        /*example*/
//        [ColumnModel parsingModelWithName:@"test" type:@"text"],
//        [ColumnModel parsingModelWithName:@"test2" type:@"integer"],
    ];
    
    return models;
}

+ (NSArray <ColumnModel *>*)getNewestLinesColumns
{
    NSArray *models = @[
    ];
    
    return models;
}

+ (NSArray <ColumnModel *>*)getNewestTagsColumns
{
    NSArray *models = @[
    ];
    
    return models;
}

#pragma mark -更新字段
+ (BOOL)addColumns:(NSArray <ColumnModel *> *)models table:(NSString *)table
{
    if (!VALID_STRING(table)) {
        return NO;
    }
    
    BOOL success = YES;
    
    FMDatabase *database = [DataManager database];
    
    for (ColumnModel *column in models) {
        if (![database columnExists:column.name inTableWithName:table]) {
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@", table, column.description];
            BOOL worked = [database executeUpdate:alertStr];
            if (!worked) {
                success = NO;
            }

        }
        
    }
    
    return success;
}


#pragma mark -开发者功能
//新增字段
+ (BOOL)addNewColumnWithName:(NSString *)name type:(NSString *)type notnull:(BOOL)notnull table:(nonnull NSString *)table
{
    ColumnModel *model = [ColumnModel parsingModelWithName:name type:type notnull:notnull];
    
    BOOL success = [self addColumns:@[model] table:table];
    
    return success;
}

//获取所有字段
+ (NSArray<ColumnModel *> *)queryAllColumnsFromTable:(NSString *)table
{
    if (!VALID_STRING(table)) {
        return nil;
    }
    
    NSString *query = [NSString stringWithFormat:@"PRAGMA table_info(%@)", table];
    
    FMResultSet *resultSet = [[DataManager database] executeQuery:query];
    
    NSMutableArray *temp = [NSMutableArray array];
    while ([resultSet next]) {
        NSString *columnName = [resultSet stringForColumn:@"name"];  //名称
        NSString *columnType = [resultSet stringForColumn:@"type"];  //类型
        int notnull = [resultSet intForColumn:@"notnull"]; //是否可空

        ColumnModel *model = [ColumnModel parsingModelWithName:columnName type:columnType notnull:notnull];
        [temp addObject: model];
    }
    
   
    return temp.copy;
    
}


@end


