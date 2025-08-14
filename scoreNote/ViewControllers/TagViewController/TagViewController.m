//
//  TagViewController.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/31.
//

#import "TagViewController.h"
#import "TagCell.h"
#import "TagDetailViewController.h"
#import "TagManager.h"

@interface TagViewController () <UITableViewDelegate, UITableViewDataSource, TagCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:kTagCell bundle:nil] forCellReuseIdentifier:kTagCell];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlick)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([TagManager sharedInstance].needUpdate) {
        [self.tableView reloadData];
        [TagManager sharedInstance].needUpdate = NO;
    }
}


#pragma mark -Action
- (void)addAlick
{
    NSString *placeholder = @"#空白";
    [SCUtilities alertWithTitle:@"输入标签名" message:nil textFieldBlock:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    } sureBlock:^(NSString * _Nullable text) {
        [self addNewTag:(text.length == 0 ? placeholder : text)];
    }];
}

- (void)addNewTag:(NSString *)tagName
{
    //检查是否有重复项
    TagModel *tag = [TagManager checkNewTagNameValid:tagName];
    
    if (tag) { //说明有相似项
        BOOL isSame = [tag.name isEqualToString:tagName]; //是否完全相同
        
        if (isSame) {  //相同不允许创建
            [self showWithStatus:@"已有同名标签，请重新输入"];
            return;
        }
        
        //相似
        [SCUtilities alertWithTitle:@"该名称和以下标签相似，请问是否继续" message:tag.name textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
            [self insertTagToDataBase:tagName];
        }];
        
    }else { //没有相似项，直接插入数据库
        [self insertTagToDataBase:tagName];
        
    }
    

}

- (void)insertTagToDataBase:(NSString *)tagName
{
    BOOL success = [TagManager insertNewTag:tagName];
    
    if (success) {
        [self showWithStatus:@"添加成功"];
        [self.tableView reloadData];
        
    }else {
        [self showWithStatus:@"添加失败"];
    }
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [TagManager pinyinList].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][section];
        return pinyin.pinyin?:@"";
    }
    
    return @"";
}

//索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *mulArr = [NSMutableArray array];
    for (TagPinyinModel *pinin in [TagManager pinyinList]) {
        [mulArr addObject:pinin.pinyin?:@""];
    }
    
    return mulArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][section];
        return pinyin.tagList.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagCell];
    
    if (indexPath.section < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][indexPath.section];
        
        if (indexPath.row < pinyin.tagList.count) {
            TagModel *model = pinyin.tagList[indexPath.row];
            cell.model = model;
            cell.delegate = self;
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][indexPath.section];
        
        if (indexPath.row < pinyin.tagList.count) {
            TagModel *model = pinyin.tagList[indexPath.row];
            if (!model.isEdit) {
                TagDetailViewController *vc = [TagDetailViewController new];
                [vc setDataWithTagId:model.tagId name:model.name records:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
}

//删除功能暂时取消
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (editingStyle != UITableViewCellEditingStyleDelete){
//        return;
//    }
//    
//    if (indexPath.section >= [TagManager pinyinList].count) {
//        return;
//    }
//    
//    TagPinyinModel *pinyin = [TagManager pinyinList][indexPath.section];
//    
//    if (indexPath.row >= pinyin.tagList.count) {
//        return;
//    }
//    
//    TagModel *tag = pinyin.tagList[indexPath.row];
//    
//    [SCUtilities alertWithTitle:@"确认删除该标签？" message:tag.name textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
//        BOOL result = [TagManager deleteTag:tag pinyin:pinyin];
//        
//        if (result) {
//            [tableView reloadData];
//            
//        }
//    }];
//    
//    
//
//}

#pragma mark -TagCellDelegate
//编辑名称
- (void)tagCellEditName:(NSString *)name model:(TagModel *)model
{
    [TagManager editName:name tag:model];
}

//编辑最大期
- (void)tagCellEditMaxCount:(NSInteger)maxCount model:(TagModel *)model
{
    [TagManager editMaxCount:maxCount tag:model];
}


@end
