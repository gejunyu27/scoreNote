//
//  TagRankViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/20.
//

#import "TagRankViewModel.h"

@implementation TagRankViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    //获取所有标签
    NSMutableArray <TagModel *>*tagModels = [DataManager queryTagModels];
    
    //获取所有记录
    NSMutableArray <RecordModel *> *records = [DataManager queryAllRecords];
    
    //数据初始化
    NSMutableArray *temp = [NSMutableArray array];
    for (TagModel *tag in tagModels) {
        TagRankModel *model = [TagRankModel new];
        model.name = tag.name;
        model.tagId = tag.tagId;
        [temp addObject:model];
    }
    
    
    //归类
    NSMutableArray *noTagList = [NSMutableArray array]; //数据库没有id的数据，临时存放
    for (RecordModel *record in records) {
        if (record.lineList.count == 0) {
            continue;
        }
        
        BOOL hasIn = NO;
        for (TagRankModel *dModel in temp) {
            if (record.tagId == dModel.tagId) {
                [dModel.recordList addObject:record];
                hasIn = YES;
                break;
            }
        }
        if (!hasIn) {
            [noTagList addObject:record];
        }
        
        
    }
    
    //把无标签的数据加进去
    TagRankModel *noTagModel = [TagRankModel new];
    noTagModel.recordList = noTagList;
    [temp addObject:noTagModel];
    
    //删除空数据&计算总利润
    [temp enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TagRankModel * _Nonnull dModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dModel.recordList.count == 0) { //删除空数据
            [temp removeObject:dModel];
            
        }else { //计算总利润
            CGFloat allProfit = 0;
            for (RecordModel *record in dModel.recordList) {
                allProfit += record.allProfit;
            }
            dModel.allProfit = allProfit;
        }
        
        
    }];
    
    //排序
    _rankList = [temp sortedArrayUsingComparator:^NSComparisonResult(TagRankModel *_Nonnull dModel1, TagRankModel *_Nonnull dModel2) {
        
        NSNumber *p1 = @(dModel1.allProfit);
        NSNumber *p2 = @(dModel2.allProfit);
        
        NSComparisonResult result = [p1 compare:p2];
        
        //        return result == NSOrderedDescending; //升序
        return result == NSOrderedAscending;  //降序
        
    }];
    
    
}
@end
