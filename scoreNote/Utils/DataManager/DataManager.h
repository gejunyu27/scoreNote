//
//  DataManager.h
//  scoreNote
//
//  Created by gejunyu on 2022/2/5.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"
#import "TagModel.h"
#import "LineModel.h"
@class FMDatabase;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (NSString *)sqliteFilePath;

#pragma mark -获取所有记录
+ (NSMutableArray <RecordModel *> *)queryAllRecords;

#pragma mark -获取在跟记录
+ (NSMutableArray <RecordModel *> *)queryFollowingRecords;

#pragma mark -获取已完成记录（根据时间倒序）
+ (NSMutableArray <RecordModel *> *)queryFinishRecords;

#pragma mark -根据标签获取记录（根据时间倒序）
+ (NSMutableArray <RecordModel *> *)queryRecordsWithTagId:(NSInteger)tagId;

#pragma mark -开发者调试用功能 删除记录
+ (BOOL)deleteRecord:(RecordModel *)record;


#pragma mark -修改记录
+ (BOOL)updateRecord:(RecordModel *)record;

#pragma mark -新增多条记录
+ (NSMutableArray <RecordModel *> *)insertNewRecords:(NSInteger)num;

#pragma mark -新增一条记录
+ (RecordModel *)insertNewRecord;

#pragma mark -根据record获取列
+ (NSMutableArray <LineModel *> *)queryLinesWithRecord:(RecordModel *)record;
   
#pragma mark -查询是否有列
+ (BOOL)hasLine:(NSString *)lineId recordId:(NSString *)recordId;

#pragma mark -新增一列
+ (LineModel *)insertNewLineWithRecord:(RecordModel *)record outMoney:(CGFloat)outMoney;

#pragma mark -修改列
+ (BOOL)updateLine:(LineModel *)line;

#pragma mark -删减一列
+ (BOOL)deleteLine:(LineModel *)line;

#pragma mark -获取所有标签
+ (NSMutableArray <TagModel *> *)queryTagModels;

#pragma mark -查询是否有标签
+ (BOOL)hasTag:(NSInteger)tagId;

#pragma mark -查询标签
+ (TagModel *)queryTag:(NSInteger)tagId;

#pragma mark -修改标签
+ (BOOL)updateTag:(TagModel *)tag;

//#pragma mark -新增标签
+ (TagModel *)insertNewTagWithName:(NSString *)name maxCount:(NSInteger)maxCount;

#pragma mark -删除标签
+ (BOOL)deleteTag:(NSInteger)tagId;

#pragma mark -导入数据库
+ (void)LeadDatabaseFrom:(NSURL *)URL;


#pragma mark -更新字段
+ (NSString *)recordTableName;
+ (NSString *)lineTableName;
+ (NSString *)tagTableName;
+ (FMDatabase *)database;
//清空
+ (void)clear;

@end

NS_ASSUME_NONNULL_END
