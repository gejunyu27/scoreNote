//
//  TagManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "TagManager.h"

@interface TagManager ()
@property (nonatomic, copy) NSMutableArray <TagPinyinModel *> *pinyinList;
@property (nonatomic, copy) baseBlock updateBlock;
@end

@implementation TagManager
DEF_SINGLETON(TagManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_SQLITE_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.pinyinList = nil;
            if (self.updateBlock) {
                self.updateBlock();
            }
        }];
    }
    return self;
}

+ (void)updateBlock:(baseBlock)updateBlock
{
    [self sharedInstance].updateBlock = updateBlock;
}

+ (NSMutableArray<TagPinyinModel *> *)pinyinList
{
    TagManager *manager = [TagManager sharedInstance];
    
    if (!manager.pinyinList || manager.pinyinList.count == 0) {
        manager.pinyinList = [self getPinyinModels];
    }
    
    return manager.pinyinList;
    
}

#pragma mark -获取拼音数据
+ (NSMutableArray <TagPinyinModel *> *)getPinyinModels
{
    //从数据获取所有标签
    NSMutableArray <TagModel *>*tags = [DataManager queryTagModels];
    
    if (tags.count == 0) {
        //生成默认数据
        tags = [self createDefaultTags];
    }
    
    //生成拼音model
    NSArray *chars = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    
    NSMutableArray *pinyinTemp = [NSMutableArray arrayWithCapacity:chars.count];
    
    for (NSString *charStr in chars) {
        TagPinyinModel *pinyin = [TagPinyinModel new];
        pinyin.pinyin = charStr;
        pinyin.tagList = [NSMutableArray array];
        [pinyinTemp addObject:pinyin];
    }
    
    //标签归类
    for (TagModel *tagModel in tags) {
        NSString *firstChar = tagModel.pinyinFirstChar ?: @"#";
        
        if ([chars containsObject:firstChar]) {
            NSInteger index = [chars indexOfObject:firstChar];
            TagPinyinModel *pinyin = pinyinTemp[index];
            [pinyin.tagList addObject:tagModel];
            tagModel.pinyin = pinyin;
            
        }
    }
    
    //移除空数据
    for (NSInteger i=pinyinTemp.count-1; i>=0; i--) {
        TagPinyinModel *pinyin = pinyinTemp[i];
        NSArray *models = pinyin.tagList;
        if (models.count == 0) {
            [pinyinTemp removeObject:pinyin];
        }
    }
    
    return pinyinTemp;
}

+ (NSMutableArray <TagModel *> *)createDefaultTags
{
    NSString *name     = @"name";
    NSString *maxCount = @"maxCount";
    
    NSArray *list = @[
        //B
        @{name:@"宝盈高赔10.0",maxCount:@111},
        @{name:@"杯中物10.0",maxCount:@53},
        @{name:@"兵工厂10.0",maxCount:@68},
        @{name:@"冰红茶",maxCount:@75},
        @{name:@"彬彬高赔",maxCount:@56},
        
        //C
        @{name:@"成功高赔",maxCount:@145},
        @{name:@"彩中中10倍",maxCount:@57},
        @{name:@"CC高赔",maxCount:@50},
        
        //D
        @{name:@"多宝10.0",maxCount:@56},
        @{name:@"大奶10.0",maxCount:@52},
        @{name:@"大鹏半全场",maxCount:@138},
        @{name:@"东方红",maxCount:@58},
        
        //F
        @{name:@"富贵3十倍",maxCount:@84},
        @{name:@"凤宝人10.0",maxCount:@92},
        
        //G
        @{name:@"光明高赔",maxCount:@58},
        @{name:@"公牛高赔",maxCount:@64},
        @{name:@"格格高赔",maxCount:@72},
        @{name:@"冠中高赔",maxCount:@74},
        @{name:@"高平10倍",maxCount:@70},
        
        //H
        @{name:@"红豆高赔",maxCount:@77},
        @{name:@"和信高赔",maxCount:@88},
        @{name:@"红中高赔",maxCount:@79},
        @{name:@"火凤凰",maxCount:@87},
        @{name:@"火单高赔",maxCount:@84},
        @{name:@"花仙子10倍",maxCount:@47},
        @{name:@"鸿运当头",maxCount:@55},
        
        //J
        @{name:@"聚焦10.0",maxCount:@47},
        @{name:@"聚缘",maxCount:@70},
        @{name:@"聚宝盆200倍",maxCount:@496},
        @{name:@"金算盘10倍",maxCount:@46},
        @{name:@"聚宝盆10倍",maxCount:@49},
        
        //K
        @{name:@"凯歌高赔",maxCount:@56},
        @{name:@"狂人10倍",maxCount:@57},
        @{name:@"凯旋高赔",maxCount:@54},
        
        //L
        @{name:@"老班长10.0",maxCount:@74},
        @{name:@"冷漠10倍",maxCount:@39},
        @{name:@"老姜头10倍",maxCount:@46},
        @{name:@"零零捌竞彩",maxCount:@59},
        @{name:@"龍单20.0",maxCount:@105},
        @{name:@"乐乐E单",maxCount:@51},
        @{name:@"龍单10.0",maxCount:@35},
        
        //M
        @{name:@"米兰高赔",maxCount:@71},
        @{name:@"梅西高赔",maxCount:@69},
        @{name:@"梅西进球",maxCount:@103},
        @{name:@"梅西半全场",maxCount:@57},
        @{name:@"米奇十倍",maxCount:@64},
        @{name:@"梅西比分",maxCount:@98},
        @{name:@"MISS张高赔",maxCount:@46},
        @{name:@"码头高赔",maxCount:@61},
        
        //N
        @{name:@"牛牛高赔",maxCount:@62},
        @{name:@"牛总10倍",maxCount:@50},
        @{name:@"暖姐高赔",maxCount:@57},
        @{name:@"牛肉面10倍",maxCount:@64},
        
        //Q
        @{name:@"麒麟解盘20倍",maxCount:@98},
        @{name:@"麒麟解盘10倍",maxCount:@42},
        
        //R
        @{name:@"任性小小余10.0",maxCount:@55},
        @{name:@"热浪10倍",maxCount:@107},
        
        //S
        @{name:@"诗人高赔",maxCount:@79},
        @{name:@"闪耀半全场",maxCount:@317},
        @{name:@"少林10倍",maxCount:@34},
        @{name:@"神针10倍",maxCount:@50},
        
        //T
        @{name:@"桃花源10倍",maxCount:@51},
        
        //W
        @{name:@"五月花十倍",maxCount:@86},
        @{name:@"威龙高赔",maxCount:@64},
        @{name:@"悟空20倍",maxCount:@119},
        @{name:@"王子10倍",maxCount:@43},
        
        //X
        @{name:@"行者10.0",maxCount:@60},
        @{name:@"熊猫高赔",maxCount:@53},
        @{name:@"小目标",maxCount:@72},
        @{name:@"向阳10倍",maxCount:@67},
        @{name:@"XG足球10倍",maxCount:@47},
        @{name:@"小公主10倍",maxCount:@41},
        @{name:@"小牛10倍",maxCount:@38},
        @{name:@"小公主20倍",maxCount:@141},
        @{name:@"小玉10倍",maxCount:@66},
        @{name:@"小姐姐高赔",maxCount:@49},
        @{name:@"星象高赔",maxCount:@33},
        @{name:@"小李哥高倍",maxCount:@45},
        
        //Y
        @{name:@"豫西北高赔",maxCount:@65},
        @{name:@"阳光里10.0",maxCount:@51},
        @{name:@"一触即发",maxCount:@54},
        @{name:@"鹰眼10倍",maxCount:@73},
        @{name:@"阳哥10倍",maxCount:@40},
        
        //Z
        @{name:@"自研10.0",maxCount:@57},

        //#
        @{name:@"#平台返水",maxCount:@0},
        @{name:@"#体彩返水",maxCount:@0},
        @{name:@"#比特币流转",maxCount:@0},
    ];
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
    
    for (NSDictionary *dict in list) {
            TagModel *tag = [DataManager insertNewTagWithName:dict[name] maxCount:[dict[maxCount] integerValue]];
            if (tag) {
                [temp addObject:tag];
            }
    }
    
    return temp;
}

#pragma mark-改变名称
+ (BOOL)editName:(NSString *)name tag:(TagModel *)tag
{
    NSString *oldName = tag.name;
    
    tag.name = name;
    
    BOOL result = [DataManager updateTag:tag];
    
    if (!result) {
        tag.name = oldName;
    }
    
    return result;
}

#pragma mark-改变最大期
+ (BOOL)editMaxCount:(NSInteger)maxCount tag:(TagModel *)tag
{
    NSInteger oldCount = tag.maxCount;
    
    tag.maxCount = maxCount;
    
    BOOL result = [DataManager updateTag:tag];
    
    if (!result) {
        tag.maxCount = oldCount;
    }
    
    return result;
}

#pragma mark-删除标签
+ (NSString *)deleteTag:(TagModel *)tag
{
    TagPinyinModel *pinyin = tag.pinyin;
    
    if (!tag || !pinyin || ![pinyin.tagList containsObject:tag]) {
        return @"标签不存在";
    }
    
    //先检测该标签下是否有过投注，有投注的禁止删除
    NSMutableArray *recordList = [DataManager queryRecordsWithTagId:tag.tagId];
    if (recordList.count > 0) {
        return @"该标签有投注记录，无法删除";
    }
    
    BOOL result = [DataManager deleteTag:tag.tagId];
    
    if (result) {
        [pinyin.tagList removeObject:tag];
        
//        if (pinyin.tagList.count == 0) { //会崩溃 重新获取应该可以但没必要， 下次打开信该字母会消失，所以暂时不做处理
//            NSMutableArray *pinyinList = [TagManager pinyinList];
//            if ([pinyinList containsObject:pinyin]) {
//                [pinyinList removeObject:pinyin];
//            }
//        }
        
        return @"";
        
    }else {
        return @"删除失败";
    }
    
}

//新增一个标签
+ (BOOL)insertNewTag:(NSString *)tagName
{
    //数据库插入新标签
    TagModel *tag = [DataManager insertNewTagWithName:tagName maxCount:0];
    
    if (tag) {
        TagManager *manager = [TagManager sharedInstance];
        manager.pinyinList = [self getPinyinModels];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -检测结束投注的真实期数，是否大于当前最大期
+ (void)checkMaxCount:(NSInteger)maxCount tagId:(NSInteger)tagId
{
    if (tagId <= 0) {
        return;
    }
    
    TagModel *currentTag;
    
    for (TagPinyinModel *pinyin in [self pinyinList]) {
        for (TagModel *tag in pinyin.tagList) {
            if (tag.tagId == tagId) {
                currentTag = tag;
                break;
            }
        }
    }
    
    if (currentTag && currentTag.maxCount < maxCount) { //新的更大 比如原本最大期20期， 本次投注 30期才中
        BOOL result = [self editMaxCount:maxCount tag:currentTag];
        if (result) {
            if ([self sharedInstance].updateBlock) {
                [self sharedInstance].updateBlock();
            }
        }
    }
    
}

#pragma mark -新建标签名称查重
+ (TagModel *)checkNewTagNameValid:(NSString *)name
{
    NSString *checkStr = [self removePrefixAndSuffix:name];

    //遍历循环查找重复名
    for (TagPinyinModel *pinyin in [self sharedInstance].pinyinList) {
        for (TagModel *tag in pinyin.tagList) {
            NSString *tagName = [self removePrefixAndSuffix:tag.name];
            if ([tagName containsString:checkStr] || [checkStr containsString:tagName]) {
                return tag;
            }
        }
    }
    
    return nil;
}

+ (NSString *)removePrefixAndSuffix:(NSString *)string
{
    NSArray *deleteArr = @[@"10.0",@"20.0",@"10倍",@"十倍",@"高赔",@"高倍",@"20倍",@"10.0倍",@"20.0倍",@"二十倍",@"抄底",@"足球",@"推荐",@"计划",@"#"]; //先去除通用名
    
    NSMutableString *checkStr = string.mutableCopy;
    
    for (NSString *str in deleteArr) {
        NSRange range = [checkStr rangeOfString:str];
        if (range.location != NSNotFound) {
            [checkStr deleteCharactersInRange:range];
        }
    }
    
    return checkStr;
}

//根据id搜索标签
+ (nullable TagModel *)getTag:(NSInteger)tagId
{
    for (TagPinyinModel *pinyin in [self pinyinList]) {
        for (TagModel *tagModel in pinyin.tagList) {
            if (tagModel.tagId == tagId) {
                return tagModel;
            }
        }
    }
    
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
