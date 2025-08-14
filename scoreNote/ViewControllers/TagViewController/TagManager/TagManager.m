//
//  TagManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "TagManager.h"

@interface TagManager ()
@property (nonatomic, copy) NSMutableArray <TagPinyinModel *> *pinyinList;
@end

@implementation TagManager
DEF_SINGLETON(TagManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTI_SQLITE_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.pinyinList = nil;
            self.needUpdate = YES;
        }];
    }
    return self;
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
        @{name:@"北斗星(夜蝶)",maxCount:@63},
        @{name:@"八零后(夜蝶)",maxCount:@44},
        @{name:@"白泽(夜蝶)",maxCount:@49},
        @{name:@"彬彬(夜蝶)",maxCount:@44},
        @{name:@"报喜10.0",maxCount:@61},
        @{name:@"冰红茶",maxCount:@75},
        @{name:@"八爪鱼",maxCount:@115},
        @{name:@"博弈高赔",maxCount:@154},
        @{name:@"白沙高赔",maxCount:@184},
        @{name:@"霸主20倍",maxCount:@255},
        
        //C
        @{name:@"成功高赔",maxCount:@145},
        @{name:@"超级高赔",maxCount:@52},
        @{name:@"春之歌(低调)",maxCount:@79},
        @{name:@"晨光",maxCount:@88},
        @{name:@"彩虹高赔",maxCount:@97},
        @{name:@"成龙(低调)",maxCount:@45},
        @{name:@"超越",maxCount:@97},
        @{name:@"草原10倍",maxCount:@95},
        @{name:@"超人10.0",maxCount:@153},
        @{name:@"苍狼10倍",maxCount:@132},
        @{name:@"草莓10倍",maxCount:@136},
        
        //D
        @{name:@"多宝10.0",maxCount:@56},
        @{name:@"大奶10.0",maxCount:@52},
        @{name:@"大鹏半全场",maxCount:@138},
        @{name:@"东方红(低调)",maxCount:@50},
        @{name:@"大地",maxCount:@105},
        @{name:@"大奔10.0",maxCount:@104},
        @{name:@"大鱼",maxCount:@111},
        @{name:@"东风高赔",maxCount:@115},
        @{name:@"顶尖10.0",maxCount:@173},
        @{name:@"东方10.0",maxCount:@177},
        
        //F
        @{name:@"富贵3十倍",maxCount:@44},
        @{name:@"凤宝人10.0",maxCount:@92},
        @{name:@"放手一搏(夜蝶)",maxCount:@51},
        @{name:@"飞翔高赔",maxCount:@101},
        @{name:@"福星10倍",maxCount:@101},
        @{name:@"法海高赔",maxCount:@146},
        @{name:@"飞马10倍",maxCount:@93},
        @{name:@"枫叶10倍",maxCount:@167},
        @{name:@"丰登10倍",maxCount:@148},
        @{name:@"锋芒20.0",maxCount:@289},
        
        //G
        @{name:@"光明高赔",maxCount:@41},
        @{name:@"公牛高赔",maxCount:@64},
        @{name:@"格格高赔",maxCount:@72},
        @{name:@"冠中高赔",maxCount:@74},
        @{name:@"功名10.0",maxCount:@109},
        @{name:@"高原高赔",maxCount:@107},
        
        //H
        @{name:@"红豆高赔",maxCount:@77},
        @{name:@"和信高赔",maxCount:@85},
        @{name:@"红中高赔",maxCount:@79},
        @{name:@"花娘高赔",maxCount:@63},
        @{name:@"火焰(低调)",maxCount:@90},
        @{name:@"火凤凰",maxCount:@87},
        @{name:@"辉哥10.0",maxCount:@40},
        @{name:@"火箭10.0",maxCount:@85},
        @{name:@"红烛10.0",maxCount:@112},
        @{name:@"花姐高赔",maxCount:@103},
        @{name:@"狐狸高赔",maxCount:@98},
        @{name:@"红旗10倍",maxCount:@123},
        @{name:@"红岩10倍",maxCount:@93},
        @{name:@"虎哥高赔",maxCount:@122},
        @{name:@"海洋高赔",maxCount:@122},
        @{name:@"红米高赔",maxCount:@104},
        @{name:@"红颜10.0",maxCount:@167},
        @{name:@"红福10倍",maxCount:@139},
        @{name:@"宏顺20倍",maxCount:@271},
        @{name:@"宏力10倍",maxCount:@103},
        @{name:@"火单高赔",maxCount:@84},
        @{name:@"红火20倍",maxCount:@176},
        
        //J
        @{name:@"聚焦10.0",maxCount:@34},
        @{name:@"军师(低调)",maxCount:@52},
        @{name:@"金泉高赔 ",maxCount:@38},
        @{name:@"聚缘",maxCount:@70},
        @{name:@"金鼠",maxCount:@73},
        @{name:@"金豆子",maxCount:@86},
        @{name:@"金鼎10.0",maxCount:@106},
        @{name:@"金杯20倍",maxCount:@133},
        @{name:@"加菲猫",maxCount:@93},
        @{name:@"金回报",maxCount:@106},
        @{name:@"君越高赔",maxCount:@89},
        @{name:@"金杯10倍",maxCount:@99},
        @{name:@"金丝熊10倍",maxCount:@120},
        @{name:@"金蟾10倍",maxCount:@111},
        @{name:@"焦点高赔",maxCount:@119},
        @{name:@"金六福半全场",maxCount:@191},
        @{name:@"金珠子20倍",maxCount:@132},
        @{name:@"金盾20倍",maxCount:@293},
        @{name:@"金牛半全场",maxCount:@179},
        @{name:@"聚宝盆200倍",maxCount:@234},
        @{name:@"橘子10倍",maxCount:@187},
        @{name:@"金冠10倍",maxCount:@145},
        @{name:@"金鱼20倍",maxCount:@259},
        @{name:@"金宝20倍",maxCount:@233},
        @{name:@"金山10.0",maxCount:@228},
        
        //K
        @{name:@"空军(低调)",maxCount:@60},
        @{name:@"凯歌(低调)",maxCount:@32},
        @{name:@"狂人",maxCount:@53},
        @{name:@"凯恩",maxCount:@123},
        @{name:@"狂飙10.0",maxCount:@199},
        
        //L
        @{name:@"老班长10.0",maxCount:@50},
        @{name:@"蓝精灵10.0",maxCount:@78},
        @{name:@"领秀高赔",maxCount:@42},
        @{name:@"冷陌(夜蝶)",maxCount:@36},
        @{name:@"李老师高赔",maxCount:@40},
        @{name:@"理想10倍",maxCount:@119},
        @{name:@"蓝天高赔",maxCount:@176},
        @{name:@"柳叶10倍",maxCount:@141},
        @{name:@"雷电10.0",maxCount:@196},
        
        //M
        @{name:@"米兰高赔",maxCount:@71},
        @{name:@"梅西高赔",maxCount:@58},
        @{name:@"梅西进球",maxCount:@84},
        @{name:@"梅西半全场",maxCount:@57},
        @{name:@"米奇十倍",maxCount:@64},
        @{name:@"魔力10.0",maxCount:@52},
        @{name:@"满江红十倍",maxCount:@68},
        @{name:@"曼陀罗(雄鹰)",maxCount:@38},
        @{name:@"木鱼石十倍",maxCount:@98},
        @{name:@"木兰(低调)",maxCount:@43},
        @{name:@"木子高赔",maxCount:@109},
        @{name:@"梅花20倍",maxCount:@112},
        @{name:@"梅西比分",maxCount:@98},
        @{name:@"马卡龙10倍",maxCount:@199},
        @{name:@"玫瑰10.0",maxCount:@193},
        
        //N
        @{name:@"牛牛高赔",maxCount:@62},
        @{name:@"Nice(十年)",maxCount:@38},
        @{name:@"农夫高赔",maxCount:@105},
        
        //P
        @{name:@"鹏程高赔",maxCount:@105},
        
        //Q
        @{name:@"秦姐高赔",maxCount:@54},
        @{name:@"青龙10.0",maxCount:@54},
        @{name:@"钱总10.0",maxCount:@35},
        @{name:@"擎天柱",maxCount:@67},
        @{name:@"青帮20.0",maxCount:@97},
        @{name:@"麒麟十倍",maxCount:@76},
        @{name:@"千里马高赔",maxCount:@96},
        @{name:@"青稞10倍",maxCount:@146},
        @{name:@"乾坤半全场",maxCount:@236},
        
        //R
        @{name:@"任性小小余10.0",maxCount:@38},
        @{name:@"如玉高赔",maxCount:@41},
        @{name:@"人参果10倍",maxCount:@102},
        @{name:@"日月高赔",maxCount:@159},
        
        //S
        @{name:@"十三朝10.0",maxCount:@24},
        @{name:@"神兽姐十倍",maxCount:@45},
        @{name:@"圣诞树10.0",maxCount:@81},
        @{name:@"四青(低调)",maxCount:@32},
        @{name:@"嵩山一号(低调)",maxCount:@43},
        @{name:@"神算盘20倍",maxCount:@131},
        @{name:@"神算盘10倍",maxCount:@75},
        @{name:@"诗人",maxCount:@79},
        @{name:@"十安10.0",maxCount:@112},
        @{name:@"盛世20倍",maxCount:@163},
        @{name:@"水仙10.0",maxCount:@170},
        
        //T
        @{name:@"兔博士高赔",maxCount:@47},
        @{name:@"天成高赔",maxCount:@32},
        @{name:@"统帅",maxCount:@73},
        @{name:@"天星10.0",maxCount:@93},
        @{name:@"天缘",maxCount:@108},
        @{name:@"天下20倍",maxCount:@174},
        @{name:@"太极10.0",maxCount:@182},
        @{name:@"太阳20.0",maxCount:@270},
        
        //V
        @{name:@"VV高赔",maxCount:@58},
        
        //W
        @{name:@"五月花十倍",maxCount:@86},
        @{name:@"威龙高赔",maxCount:@40},
        @{name:@"万足金10.0",maxCount:@60},
        @{name:@"悟空20倍",maxCount:@119},
        @{name:@"万通20倍",maxCount:@219},
        @{name:@"完美高赔",maxCount:@100},
        @{name:@"无极20.0",maxCount:@265},
        
        //X
        @{name:@"行者10.0",maxCount:@60},
        @{name:@"幸运星10.0",maxCount:@65},
        @{name:@"熊猫高赔",maxCount:@49},
        @{name:@"星光足球10.0",maxCount:@45},
        @{name:@"小样(低调)",maxCount:@39},
        @{name:@"小熙(低调)",maxCount:@66},
        @{name:@"小青10.0",maxCount:@54},
        @{name:@"仙缘10.0",maxCount:@91},
        @{name:@"小目标",maxCount:@72},
        @{name:@"枭龙高赔",maxCount:@51},
        @{name:@"星辰10倍",maxCount:@147},
        @{name:@"小帅10.0",maxCount:@119},
        @{name:@"向阳10倍",maxCount:@67},
        
        //Y
        @{name:@"豫西北高赔",maxCount:@65},
        @{name:@"咏春",maxCount:@107},
        @{name:@"一支梅(低调)",maxCount:@80},
        @{name:@"阳光里10.0",maxCount:@41},
        @{name:@"渔人码头",maxCount:@50},
        @{name:@"玉衣10.0",maxCount:@77},
        @{name:@"一触即发",maxCount:@54},
        @{name:@"元宝20.0",maxCount:@188},
        @{name:@"亿鑫20.0",maxCount:@171},
        @{name:@"云飞20倍",maxCount:@134},
        @{name:@"银河10倍",maxCount:@101},
        @{name:@"阳光10倍",maxCount:@137},
        @{name:@"月亮10倍",maxCount:@176},
        @{name:@"鹰眼10倍",maxCount:@73},
        
        //Z
        @{name:@"自研10.0",maxCount:@57},
        @{name:@"战狼10.0",maxCount:@91},
        @{name:@"至尊半全场",maxCount:@141},
        @{name:@"中华高赔",maxCount:@123},
        @{name:@"珠峰高赔",maxCount:@84},

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
+ (BOOL)deleteTag:(TagModel *)tag pinyin:(nonnull TagPinyinModel *)pinyin
{
    BOOL result = [DataManager deleteTag:tag.tagId];
    
    if (result) {
        if ([pinyin.tagList containsObject:tag]) {
            [pinyin.tagList removeObject:tag];
            
//            NSMutableArray *pinyinList = [TagManager pinyinList];
//            
//            if (pinyin.tagList.count == 0 && [pinyinList containsObject:pinyin]) {
//                [pinyinList removeObject:pinyin];
//            } //会崩溃，暂时放着
            
        }
        
        
    }
    
    return result;
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
            [self sharedInstance].needUpdate = YES;
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
