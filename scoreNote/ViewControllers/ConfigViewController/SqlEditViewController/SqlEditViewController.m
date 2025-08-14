//
//  SqlEditViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import "SqlEditViewController.h"
#import "CommonHeaderView.h"
#import "SqlLineViewController.h"
#import "SqlEditUtil.h"
#import "TagSelectView.h"

typedef NS_ENUM(NSInteger, SqlRecordType) {
    SqlRecordTypeCreateTime,
    SqlRecordTypeEndTime,
    SqlRecordTypeIsOver,
    SqlRecordTypeLines,
    SqlRecordTypeTag,
    SqlRecordTypeDelete
};

@interface SqlEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <RecordModel *> *recordList;
@end

@implementation SqlEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改数据库数据";
    
    _recordList = [DataManager queryAllRecords];
    
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlick)];
    
    [self showWithStatus:@"该页面仅用于开发测试，建议先备份数据库"];
    
}

#pragma mark -action
- (void)addAlick
{
    [SCUtilities alertWithTitle:@"确定要新建一个记录吗？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        RecordModel *record = [DataManager insertNewRecord];
        
        if (record) {
            [self showWithStatus:@"新增成功"];
            [self.recordList addObject:record];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"新增失败"];
        }
    }];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCommonHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommonHeaderView];
    
    if (section < _recordList.count) {
        RecordModel *record = _recordList[section];
        [header setSqlRecord:record section:section];
    }
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SqlRecordTypeDelete+1;
}

//索引
#define kIndexRatio 20 //索引倍数
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *mulArr = [NSMutableArray array];
    
    NSInteger ratio = _recordList.count/kIndexRatio + 1;
    
    for (NSInteger i=0; i<ratio; i++) {
        NSString *title = [NSString stringWithFormat:@"%li", i*kIndexRatio+1];
        [mulArr addObject:title];
    }
    
    return mulArr;
}

//点击索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index*kIndexRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section < _recordList.count) {
        RecordModel *record = _recordList[indexPath.section];
        
        switch (indexPath.row) {
            case SqlRecordTypeCreateTime:
            {
                NSString *dateString = [SqlEditUtil getDateString:record.createTime prefix:@"创建时间" placeholder:@"（进行中）"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@（不可修改）", dateString];
                
            }
                break;
                
            case SqlRecordTypeEndTime:
                cell.textLabel.text = [SqlEditUtil getDateString:record.endTime prefix:@"结束时间" placeholder:@"（进行中）"];
                break;
                
            case SqlRecordTypeIsOver:
                cell.textLabel.text = [NSString stringWithFormat:@"是否结束：%@", (record.isOver?@"是":@"否")];
                break;
                
            case SqlRecordTypeLines:
                cell.textLabel.text = [NSString stringWithFormat:@"查看列表：共%li单   总利润：%@", record.lineList.count, [SCUtilities removeFloatSuffix:record.allProfit]];
                break;
                
            case SqlRecordTypeTag:
                cell.textLabel.text = [NSString stringWithFormat:@"标签编号：%li", record.tagId];
                break;
                
            case SqlRecordTypeDelete:
                cell.textLabel.text = @"删除";
                break;
                
            default:
                break;
        }
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < _recordList.count) {
        
        RecordModel *record = _recordList[indexPath.section];
        
        
        switch (indexPath.row) {
            case SqlRecordTypeCreateTime:
                break;
                
            case SqlRecordTypeEndTime:
                [self editEndTime:record];
                break;
                
            case SqlRecordTypeIsOver:
                [self editIsOver:record];
                break;
                
            case SqlRecordTypeLines:
                [self pushLines:record];
                break;
                
            case SqlRecordTypeTag:
                [self selectTag:record];
                
                break;
                
            case SqlRecordTypeDelete:
                [self deleteRecord:record];
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark -数据库改动
- (void)editEndTime:(RecordModel *)record
{
    NSString *title = [NSString stringWithFormat:@"确定修改编号%@结束时间吗", record.recordId];
    NSString *dateStr = [SqlEditUtil getDateString:record.endTime prefix:nil placeholder:nil];
    
    [SCUtilities alertWithTitle:title message:@"请按照2024-10-1格式填写，小时、分钟可以省略" textFieldBlock:^(UITextField * _Nonnull textField) {
        textField.text = dateStr;
            
        } sureBlock:^(NSString * _Nullable text) {
            if ([text isEqualToString:dateStr]) {
                return;
            }
            
            NSDate *endTime = [SqlEditUtil getEditDate:text];
            NSDate *oldEndTime = record.endTime;
            record.endTime = endTime;
            
            BOOL success = [DataManager updateRecord:record];
            
            if (success) {
                [self showWithStatus:@"修改成功"];
                [self.tableView reloadData];
            }else {
                [self showWithStatus:@"修改失败"];
                record.endTime = oldEndTime;
            }

        }];
}

- (void)editIsOver:(RecordModel *)record
{
    NSString *title = [NSString stringWithFormat:@"确定将编号%@结束状态改为%@吗",  record.recordId,record.isOver?@"未结束":@"结束"];
    [SCUtilities alertWithTitle:title message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        record.isOver^=1;
        
        BOOL success = [DataManager updateRecord:record];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"修改失败"];
            record.isOver^=1;
        }
    }];
}

- (void)pushLines:(RecordModel *)record
{
    SqlLineViewController *vc = [SqlLineViewController new];
    vc.record = record;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectTag:(RecordModel *)record
{
    [TagSelectView show:^(TagModel * _Nullable tag) {
        NSInteger oldTagId = tag.tagId;
        
        record.tagId = tag.tagId;
        
        BOOL success = [DataManager updateRecord:record];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"修改失败"];
            record.tagId = oldTagId;
        }
    }];
}

- (void)deleteRecord:(RecordModel *)record
{
    NSString *title = [NSString stringWithFormat:@"确定要删除编号%@吗", record.recordId];
    [SCUtilities alertWithTitle:title message:@"警告：该操作不可逆" textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        BOOL success = [DataManager deleteRecord:record];
        
        if (success) {
            [self showWithStatus:@"删除成功"];
            [self.recordList removeObject:record];
            [self.tableView reloadData];
            
        }else {
            [self showWithStatus:@"删除失败"];
        }
        
    }];
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerClass:CommonHeaderView.class forHeaderFooterViewReuseIdentifier:kCommonHeaderView];
        //        [_tableView registerNib:[UINib nibWithNibName:kCareerCell bundle:nil] forCellReuseIdentifier:kCareerCell];
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
