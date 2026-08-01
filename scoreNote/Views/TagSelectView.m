//
//  TagSelectView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import "TagSelectView.h"
#import "TagManager.h"

@interface TagSelectView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) TagSelectBlock selectBlock;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) NSInteger selectedTagId;
@end


@implementation TagSelectView
+ (void)show:(TagSelectBlock)selectBlock
{
    [self show:selectBlock selectedTagId:-1];
}

+ (void)show:(TagSelectBlock)selectBlock selectedTagId:(NSInteger)selectedTagId
{
    [SCUtilities endEditing];
    
    UITabBarController *vc = [SCUtilities currentTabBarController];
    
    TagSelectView *selectView = [[TagSelectView alloc] initWithFrame:vc.view.bounds selectBlock:selectBlock selectedTagId:selectedTagId];
    
    [vc.view addSubview:selectView];
}

- (instancetype)initWithFrame:(CGRect)frame selectBlock:(TagSelectBlock)selectBlock selectedTagId:(NSInteger)selectedTagId
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectBlock = selectBlock;
        _selectedTagId = selectedTagId;
        
        //背景色
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        //刷新
        [self.tableView reloadData];
        
        //跳转
        [self scrollToSelectedTagId];
    }
    return self;
}

- (void)scrollToSelectedTagId
{
    if (_selectedTagId <= 0) {
        return;
    }
    
    __block NSInteger section=-1;
    __block NSInteger row=-1;
    
    [[TagManager pinyinList] enumerateObjectsUsingBlock:^(TagPinyinModel * _Nonnull pinyin, NSUInteger ids, BOOL * _Nonnull stop) {
        [pinyin.tagList enumerateObjectsUsingBlock:^(TagModel * _Nonnull tag, NSUInteger idr, BOOL * _Nonnull stop) {
            if (tag.tagId == self.selectedTagId) {
                section = ids+1;
                row = idr;
                *stop = YES;
            }
        }];
        
        if (section > 0 && row >=0) {
            *stop = YES;
        }
    }];
    
    if (section > 0 && row >=0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }

}


#pragma mark -btnAction
- (void)cancelClicked
{
    [self removeFromSuperview];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [TagManager pinyinList].count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
        
    }else if (section - 1 < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][section-1];
        return pinyin.pinyin;
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
        
    }else if (section-1 < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][section-1];
        return pinyin.tagList.count;
    }
    
    return 0;
}

//索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *mulArr = [NSMutableArray arrayWithObject:@""];
    for (TagPinyinModel *pinin in [TagManager pinyinList]) {
        [mulArr addObject:pinin.pinyin?:@""];
    }
    
    return mulArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        cell.textLabel.text = @"无标签";
        
    }else if (section-1 < [TagManager pinyinList].count) {
        TagPinyinModel *pinyin = [TagManager pinyinList][section-1];
        
        NSArray *tagList = pinyin.tagList;
        
        if (indexPath.row < tagList.count) {
            TagModel *tag = tagList[indexPath.row];
            
            NSString *title = [NSString stringWithFormat:@"%@-- %@    最大%li期", pinyin.pinyin, tag.name, tag.maxCount];
            
            cell.textLabel.text = title;
            
            if (_selectedTagId > 0 && tag.tagId == _selectedTagId) {
                cell.textLabel.textColor = [UIColor redColor];
                
            }else {
                cell.textLabel.textColor = [UIColor blackColor];
            }
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_selectBlock) {
        [self cancelClicked];
        return;
    }
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        _selectBlock(nil);
        
    }else {
        TagPinyinModel *pinyin = [TagManager pinyinList][section-1];
        
        NSArray *tagList = pinyin.tagList;
        
        if (indexPath.row < tagList.count) {
            TagModel *tag = tagList[indexPath.row];
            _selectBlock(tag);
            
        }
    }
    
    [self cancelClicked];
}

#pragma mark -ui
- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        CGFloat x = 10;
        CGFloat h = 60;
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(x, self.height- SCREEN_SAFE_BOTTOM - h, self.width-2*x, h)];
        _cancelButton.layer.cornerRadius = 10;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = SCFONT_BOLD_SIZED(20);
        [_cancelButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat y = NAV_BAR_HEIGHT;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.cancelButton.left, y, self.cancelButton.width, self.cancelButton.top - y - 10)];
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.rowHeight = 60;
        _tableView.sectionHeaderTopPadding = 0;
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
