//
//  TagManager.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
#import "TagPinyinModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagManager : NSObject

AS_SINGLETON(TagManager)
//数据是否因外部情况产生变化 ui未能及时更新 例如接收到通知
@property (nonatomic, assign) BOOL needUpdate;

//获取拼音列表
+ (NSMutableArray <TagPinyinModel *> *)pinyinList;

//改变名称
+ (BOOL)editName:(NSString *)name tag:(TagModel *)tag;
//改变最大期
+ (BOOL)editMaxCount:(NSInteger)maxCount tag:(TagModel *)tag;
//删除标签
+ (BOOL)deleteTag:(TagModel *)tag pinyin:(TagPinyinModel *)pinyin;
//新增一个标签
+ (BOOL)insertNewTag:(NSString *)tagName;
//检测结束投注的真实期数，是否大于当前最大期
+ (void)checkMaxCount:(NSInteger)maxCount tagId:(NSInteger)tagId;

//新建标签名称查重
+ (nullable TagModel *)checkNewTagNameValid:(NSString *)name;

//根据id搜索标签
+ (nullable TagModel *)getTag:(NSInteger)tagId;

@end




NS_ASSUME_NONNULL_END
