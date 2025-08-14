//
//  DataManager.m
//  scoreNote
//
//  Created by gejunyu on 2022/2/5.
//

#import "DataManager.h"
#import <FMDB.h>
#import "ColumnManager.h"

//记录表
#define t_record    @"t_record"
//列表
#define t_line      @"t_line"
//标签表
#define t_tag       @"t_tag"

//db
#define kDatabase [DataManager sharedInstance].db

@interface DataManager ()
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DataManager
DEF_SINGLETON(DataManager)

#pragma mark -获取所有记录
+ (NSMutableArray <RecordModel *> *)queryAllRecords
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id", t_record];
    FMResultSet *rs = [kDatabase executeQuery:sql];
    
    NSMutableArray *records = [self getRecordsFrom:rs];
    
    return records;
}

#pragma mark -获取在跟记录
+ (NSMutableArray <RecordModel *> *)queryFollowingRecords
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE isOver = 0 ORDER BY id", t_record];
    FMResultSet *rs = [kDatabase executeQuery:sql];
    
    NSMutableArray *records = [self getRecordsFrom:rs];
    
    return records;
}

#pragma mark -获取已完成记录（倒序）
+ (NSMutableArray <RecordModel *> *)queryFinishRecords
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE isOver = 1 ORDER BY endTime DESC", t_record];
    FMResultSet *rs = [kDatabase executeQuery:sql];
    
    NSMutableArray *records = [self getRecordsFrom:rs];
        
    return records;
}

#pragma mark -根据标签获取记录（倒序）
+ (NSMutableArray <RecordModel *> *)queryRecordsWithTagId:(NSInteger)tagId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE tagId = ? ORDER BY endTime DESC", t_record];
    FMResultSet *rs = [kDatabase executeQuery:sql, @(tagId)];
    
    NSMutableArray *records = [self getRecordsFrom:rs];
    
    return records;
}

+ (NSMutableArray <RecordModel *> *)getRecordsFrom:(FMResultSet *)rs
{
    NSMutableArray *temp = [NSMutableArray array];
    while ([rs next]) {
        RecordModel *record = [RecordModel new];
        
        record.recordId      = [NSString stringWithFormat:@"%i", [rs intForColumn:@"id"]];
        record.profitPerLine = [rs doubleForColumn:@"profitPerLine"];
        record.tagId         = [rs intForColumn:@"tagId"];
        record.baseProfit    = [rs doubleForColumn:@"baseProfit"];
        record.realNum       = [rs intForColumn:@"realNum"];
        record.note          = [rs stringForColumn:@"note"];
        record.isOver        = [rs intForColumn:@"isOver"];
        record.currentScore  = [rs stringForColumn:@"currentScore"];
        record.overTagName   = [rs stringForColumn:@"overTagName"];
        
        
        NSString *createTime = [rs stringForColumn:@"createTime"];
        if (createTime.length > 0) {
            record.createTime = [NSDate dateWithTimeIntervalSince1970:createTime.floatValue];
        }
        
        
        NSString *endTime = [rs stringForColumn:@"endTime"];
        if (endTime.length > 0) {
            record.endTime = [NSDate dateWithTimeIntervalSince1970:endTime.floatValue];
        }
        
        //获取列
        NSMutableArray <LineModel *> *lines = [self queryLinesWithRecord:record];
        record.lineList = lines;
        
        [temp addObject:record];
    }
    
    return temp;
}

//查询是否有记录
+ (BOOL)hasRecord:(NSString *)recordId
{
    if (!recordId) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ?", t_record];
    
    FMResultSet *rs = [kDatabase executeQuery:sql, recordId];
    
    BOOL has = NO;
    while ([rs next]) {
        has = YES;
        break;
    }
    
    return has;
}

#pragma mark -修改记录
+ (BOOL)updateRecord:(RecordModel *)record
{
    if (![self hasRecord:record.recordId]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET profitPerLine = ?, baseProfit = ?, endTime = ?, tagId = ?, realNum = ?, note = ?, isOver = ?, currentScore = ?, overTagName = ? WHERE id = ?", t_record];
    BOOL result = [kDatabase executeUpdate:sql, @(record.profitPerLine), @(record.baseProfit), record.endTime, @(record.tagId), @(record.realNum), (record.note?:@""), @(record.isOver?1:0), (record.currentScore?:@""), (record.overTagName?:@""), record.recordId];
    
    if (result) {
        [self postRecordUpdateNoti];
    }
    
    return result;
}

#pragma mark -开发者调试用功能 删除记录
+ (BOOL)deleteRecord:(RecordModel *)record
{
    if (!record || record.recordId.length == 0) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",t_record];
    BOOL result = [kDatabase executeUpdate:sql, record.recordId];
    return result;
}

#pragma mark -新增多条记录
+ (NSMutableArray <RecordModel *> *)insertNewRecords:(NSInteger)num
{
    if (num <= 0) {
        return nil;
    }
    
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (profitPerLine,createTime) VALUES ", t_record];
//
//    for (NSInteger i = 0; i<num; i++) {
//        if (i > 0) {
//            [sql appendString:@","];
//        }
//        [sql appendFormat:@"(%f,%@)", LINE_PROFIT, [NSDate date]];
//
//    }
//    BOOL result = [kDatabase executeUpdate:sql];
//
//    if (!result) {
//        return nil;
//    }
    NSInteger failNum = 0;
    for (NSInteger i=0; i<num; i++) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (profitPerLine,createTime,isOver) VALUES (?,?,?)", t_record];
        BOOL result =  [kDatabase executeUpdate:sql, @(LINE_PROFIT), [NSDate date], @0];
        if (!result) {
            failNum++;
        }
    }
    
    
    //返回刚刚新增的记录
    NSString *backSql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 0,%li", t_record, num-failNum];
    FMResultSet *rs = [kDatabase executeQuery:backSql];
    
    NSMutableArray <RecordModel *> *records = [self getRecordsFrom:rs];
    
    //因为是倒序取的数据，所以这里顺序要颠倒一下
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:records.count];
    [records enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(RecordModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:model];
    }];
    
    [self postRecordUpdateNoti];
    
    return temp;
}

#pragma mark -新增记录
+ (RecordModel *)insertNewRecord
{
    NSMutableArray *records = [self insertNewRecords:1];
   
    RecordModel *record = records.count > 0 ? records.firstObject : nil;
    
    [self postRecordUpdateNoti];
    
    return record;
}

#pragma mark -根据record获取列
+ (NSMutableArray <LineModel *> *)queryLinesWithRecord:(RecordModel *)record
{
    if (record.recordId.length == 0) {
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE recordId = ? ORDER BY id", t_line];
    FMResultSet *rs = [kDatabase executeQuery:sql, record.recordId];
    
    NSMutableArray *lines = [self getLinesFrom:rs record:record];
    return lines;
}

+ (NSMutableArray <LineModel *> *)getLinesFrom:(FMResultSet *)rs record:(RecordModel *)record
{
    NSMutableArray *temp = [NSMutableArray array];
    while ([rs next]) {
        LineModel *line = [LineModel new];
        line.lineId     = [NSString stringWithFormat:@"%i", [rs intForColumn:@"id"]];
        line.outMoney   = [rs doubleForColumn:@"outMoney"];
        line.getMoney   = [rs doubleForColumn:@"getMoney"];
        line.isOver     = [rs intForColumn:@"isOver"];
        line.recordId   = [rs stringForColumn:@"recordId"];
        line.record     = record;
        line.overScore  = [rs stringForColumn:@"overScore"];
        
        NSString *beginTime = [rs stringForColumn:@"beginTime"];
        if (beginTime.length > 0) {
            line.beginTime = [NSDate dateWithTimeIntervalSince1970:beginTime.floatValue];
        }
        
        NSString *endTime = [rs stringForColumn:@"endTime"];
        if (endTime.length > 0) {
            line.endTime = [NSDate dateWithTimeIntervalSince1970:endTime.floatValue];
        }
        
        
        [temp addObject:line];
    }
    
    return temp;
}

#pragma mark -查询是否有列
+ (BOOL)hasLine:(NSString *)lineId recordId:(NSString *)recordId
{
    if (!lineId || !recordId) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE recordId = ? AND id = ?", t_line];
    
    FMResultSet *rs = [kDatabase executeQuery:sql, recordId, lineId];
    
    BOOL has = NO;
    while ([rs next]) {
        has = YES;
        break;
    }
    
    return has;
}

#pragma mark -新增一列
+ (LineModel *)insertNewLineWithRecord:(RecordModel *)record outMoney:(CGFloat)outMoney
{
    NSString *recordId = record.recordId;
    if (recordId == 0) {
        return nil;
    }
    
    //添加新列
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (recordId,beginTime,outMoney) VALUES (?,?,?)", t_line];
    BOOL result = [kDatabase executeUpdate:sql, recordId, [NSDate date], @(outMoney)];
    
    if (!result) {
        return nil;
    }
    
    //返回刚刚新增的记录
    NSString *backSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE recordId = ? ORDER BY id DESC LIMIT 0,1 ", t_line];
    FMResultSet *rs = [kDatabase executeQuery:backSql, recordId];
    
    NSArray *lines = [self getLinesFrom:rs record:record];
    
    LineModel *line = lines.count > 0 ? lines.firstObject : nil;
    
    [self postRecordUpdateNoti];
    
    return line;
}

#pragma mark -修改列
+ (BOOL)updateLine:(LineModel *)line
{
    if (![self hasLine:line.lineId recordId:line.recordId]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET outMoney = ?,getMoney = ?,beginTime = ?, endTime = ?,isOver = ?,overScore = ? WHERE id = ? AND recordId = ?", t_line];
    BOOL result = [kDatabase executeUpdate:sql, @(line.outMoney), @(line.getMoney), line.beginTime,  line.endTime, @(line.isOver?1:0), line.overScore, line.lineId, line.recordId];
    
    if (result) {
        [self postRecordUpdateNoti];
    }
   
    return result;
}

#pragma mark -删减一列
+ (BOOL)deleteLine:(LineModel *)line
{
    if (![self hasLine:line.lineId recordId:line.recordId]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ? AND recordId = ?",t_line];
    BOOL result = [kDatabase executeUpdate:sql, line.lineId, line.recordId];
    
    if (result) {
        [self postRecordUpdateNoti];
    }
    
    return result;
}

#pragma mark -获取所有标签
+ (NSMutableArray <TagModel *> *)queryTagModels
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", t_tag];
    
    FMResultSet *rs = [kDatabase executeQuery:sql];
    
    return [self getTagsFrom:rs];

}

+ (NSMutableArray <TagModel *> *)getTagsFrom:(FMResultSet *)rs
{
    NSMutableArray *temp = [NSMutableArray array];
    
    while ([rs next]) {
        TagModel *model = [TagModel new];
        model.name        = [rs stringForColumn:@"name"];
        model.maxCount    = [rs intForColumn:@"maxCount"];
        model.tagId       = [rs intForColumn:@"id"];

        [temp addObject:model];
        
    }

    return temp;
}

#pragma mark -查询是否有标签
+ (BOOL)hasTag:(NSInteger)tagId
{
    if (tagId <= 0) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ?", t_tag];
    
    FMResultSet *rs = [kDatabase executeQuery:sql, @(tagId)];
    
    BOOL has = NO;
    while ([rs next]) {
        has = YES;
        break;
    }
    
    return has;
}

#pragma mark -查询标签
+ (TagModel *)queryTag:(NSInteger)tagId
{
    if (tagId == 0) {
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ?", t_tag];
    
    FMResultSet *rs = [kDatabase executeQuery:sql, @(tagId)];
    
    NSArray *list = [self getTagsFrom:rs];
    
    return list.count > 0 ? list.firstObject : nil;
}

#pragma mark -修改标签
+ (BOOL)updateTag:(TagModel *)tag
{
    if (![self hasTag:tag.tagId]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name = ?, maxCount = ?  WHERE id = ?", t_tag];
    BOOL result = [kDatabase executeUpdate:sql, (tag.name?:@""), @(tag.maxCount), @(tag.tagId)];
    return result;
}

#pragma mark -新增标签
+ (TagModel *)insertNewTagWithName:(NSString *)name maxCount:(NSInteger)maxCount
{
    //添加新标签
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (name,maxCount) VALUES (?,?)", t_tag];
    BOOL result = [kDatabase executeUpdate:sql, (name?:@""), @(maxCount)];
    
    if (!result) {
        return nil;
    }
    
    //返回刚刚插入的数据
    NSString *backSql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 0,1 ", t_tag];
    FMResultSet *rs = [kDatabase executeQuery:backSql];
    
    NSArray *tags = [self getTagsFrom:rs];
    
    TagModel *tag = tags.count > 0 ? tags.firstObject : nil;
    
    return tag;
}

#pragma mark -删除标签
+ (BOOL)deleteTag:(NSInteger)tagId
{
    if (![self hasTag:tagId]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",t_tag];
    BOOL result = [kDatabase executeUpdate:sql, @(tagId)];
    
    return result;
}

#pragma mark -导入数据库
+ (void)LeadDatabaseFrom:(NSURL *)URL
{
    NSString *localPath = [DataManager sqliteFilePath];
    
    BOOL hasLocal = [[NSFileManager defaultManager] fileExistsAtPath:localPath];
    
    BOOL needLead = !hasLocal || [URL.absoluteString.lastPathComponent isEqualToString:localPath.lastPathComponent];
    
    //不需要导入
    if (!needLead) {
        //移除文件
        [self removeInboxFile:URL];
        return;
    }
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:(hasLocal ? @"要替换本地数据库吗" : @"要导入数据库吗") message:nil preferredStyle:UIAlertControllerStyleAlert];

    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeInboxFile:URL];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (hasLocal) {
            NSError *error;
            BOOL result = [[NSFileManager defaultManager] removeItemAtPath:localPath error:&error];
            if (!result || error) {
                [self showWithStatus:@"本地文件清除失败"];
                [self removeInboxFile:URL];
                return;
            }
        }
        
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] moveItemAtURL:URL toURL:[NSURL fileURLWithPath:localPath] error:&error];
        if (!result || error) {
            [self showWithStatus:@"导入失败"];
            
        }else {
            //清除数据
            [DataManager clear];
            
        }
        
        [self removeInboxFile:URL];

    }]];
    
    [[SCUtilities currentViewController] presentViewController:ac animated:YES completion:nil];

    
}

+ (void)removeInboxFile:(NSURL *)URL
{
    if ([URL.absoluteString containsString:@"Inbox"]) {
        [[NSFileManager defaultManager] removeItemAtURL:URL error:nil];
    }
}

#pragma mark -init
- (FMDatabase *)db
{
    if (!_db) {
        //1.创建数据库对象
        _db = [FMDatabase databaseWithPath:[DataManager sqliteFilePath]];
        
        //2.打开数据库
        if ([_db open]) {

            //3.创建记录表
            NSString *recordSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, profitPerLine real, createTime text NOT NULL, endTime text, tagId integer, baseProfit real, realNum integer, note text, isOver integer, currentScore text, overTagName text)", t_record];
            [_db executeUpdate:recordSql];
            
            //4.创建列表
            NSString *lineSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, recordId text NOT NULL, outMoney real, getMoney real, isOver integer, beginTime text, endTime text, overScore text)", t_line];
            [_db executeUpdate:lineSql];
            
            //5.创建标签表
            NSString *tagSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, maxCount integer)", t_tag];
            [_db executeUpdate:tagSql];
            
            
        }
        
        //3.更新字段
        [ColumnManager updateColumns];

    }
    return _db;
}

+ (NSString *)sqliteFilePath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"scoreNote.sqlite"];
    return path;
}

+ (NSString *)recordTableName
{
    return t_record;
}

+ (NSString *)lineTableName
{
    return t_line;
}

+ (NSString *)tagTableName
{
    return t_tag;
}

+ (FMDatabase *)database
{
    return kDatabase;
}

+ (void)postRecordUpdateNoti //发送记录变更通知
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RECORD_UPDATE object:nil];
}

+ (void)clear
{
    kDatabase = nil;

    //清除保存的一些记录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_HIGH_PROFIT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_LOW_PROFIT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_DB_VERSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发送数据库清空通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SQLITE_UPDATE object:nil];
}

- (void)dealloc
{
    [_db close];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
