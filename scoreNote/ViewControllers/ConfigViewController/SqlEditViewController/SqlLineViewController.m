//
//  SqlLineViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import "SqlLineViewController.h"
#import "CommonHeaderView.h"
#import "SqlEditUtil.h"

typedef NS_ENUM(NSInteger, SqlLineType) {
    SqlLineTypeOutMoney,
    SqlLineTypeGetMoney,
    SqlLineTypeIsOver,
    SqlLineTypeBeginTime,
    SqlLineTypeEndTime,
    SqlLineTypeOverScore,
    SqlLineTypeDelete
};

@interface SqlLineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation SqlLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlick)];
}

- (void)setRecord:(RecordModel *)record
{
    _record = record;
    
    self.title = [NSString stringWithFormat:@"编号：%@", record.recordId];
    
    [self.tableView reloadData];
}

#pragma mark -action
- (void)addAlick
{
    [SCUtilities alertWithTitle:@"确定要新建一列吗？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        LineModel *line = [DataManager insertNewLineWithRecord:self.record outMoney:0];
        
        if (line) {
            [self showWithStatus:@"新增成功"];
            [self.record.lineList addObject:line];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"新增失败"];
        }
    }];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _record.lineList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCommonHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommonHeaderView];
    
    if (section < _record.lineList.count) {
        LineModel *line = _record.lineList[section];
        [header setSqlLine:line section:section];
    }
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _record.lineList.count) {
        return SqlLineTypeDelete+1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section < _record.lineList.count) {
        LineModel *line = _record.lineList[indexPath.section];

        switch (indexPath.row) {
            case SqlLineTypeOutMoney:
                cell.textLabel.text = [NSString stringWithFormat:@"投入：%@", [SCUtilities removeFloatSuffix:line.outMoney]];
                break;
                
            case SqlLineTypeGetMoney:
                cell.textLabel.text = [NSString stringWithFormat:@"收入：%@", [SCUtilities removeFloatSuffix:line.getMoney]];
                break;
                
            case SqlLineTypeIsOver:
                cell.textLabel.text = [NSString stringWithFormat:@"是否结束：%@", line.isOver?@"是":@"否"];
                
                break;
                
            case SqlLineTypeBeginTime:
                cell.textLabel.text = [SqlEditUtil getDateString:line.beginTime prefix:@"开始时间" placeholder:nil];
                break;
                
            case SqlLineTypeEndTime:
                cell.textLabel.text = [SqlEditUtil getDateString:line.endTime prefix:@"结束时间" placeholder:@"（进行中）"];
                break;
                
            case SqlLineTypeOverScore:
                cell.textLabel.text = [NSString stringWithFormat:@"当期买法：%@", (VALID_STRING(line.overScore) ? line.overScore : @"未记录")];
                break;
                
            case SqlLineTypeDelete:
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
    if (indexPath.section < _record.lineList.count) {
        LineModel *line = _record.lineList[indexPath.section];
        
        switch (indexPath.row) {
            case SqlLineTypeOutMoney:
                [self editOutMoney:line];
                break;
            
            case SqlLineTypeGetMoney:
                [self editGetMoney:line];
                break;
                
            case SqlLineTypeIsOver:
                [self editIsOver:line];
                break;
                
            case SqlLineTypeBeginTime:
                [self editBeginTime:line];
                break;
            
            case SqlLineTypeEndTime:
                [self editEndTime:line];
                break;
                
            case SqlLineTypeOverScore:
                [self editOverScore:line];
                break;
                
            case SqlLineTypeDelete:
                [self deleteLine:line];
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark -修改数据库
- (void)editOutMoney:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"修改编号%@支出", line.lineId];
    [NumberInputView showWithText:[SCUtilities removeFloatSuffix:line.outMoney] title:title clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        
        CGFloat oldOutMoney = line.outMoney;
        
        line.outMoney = outputText.floatValue;
        
        BOOL success = [DataManager updateLine:line];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
            
        }else {
            [self showWithStatus:@"修改失败"];
            line.outMoney = oldOutMoney;
        }
    }];
}

- (void)editGetMoney:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"修改编号%@收入", line.lineId];
    [NumberInputView showWithText:[SCUtilities removeFloatSuffix:line.getMoney] title:title clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        
        CGFloat oldGetMoney = line.getMoney;
        
        line.getMoney = outputText.floatValue;
        
        BOOL success = [DataManager updateLine:line];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
            
        }else {
            [self showWithStatus:@"修改失败"];
            line.getMoney = oldGetMoney;
        }
    }];
}

- (void)editIsOver:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"确定将编号%@结束状态改为%@吗",  line.lineId,line.isOver?@"未结束":@"结束"];
    [SCUtilities alertWithTitle:title message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        line.isOver^=1;
        
        BOOL success = [DataManager updateLine:line];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"修改失败"];
            line.isOver^=1;
        }
    }];
}

- (void)editBeginTime:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"确定修改编号%@开始时间吗", line.lineId];
    NSString *dateStr = [SqlEditUtil getDateString:line.beginTime prefix:nil placeholder:nil];
    [SCUtilities alertWithTitle:title message:@"请按照2024-10-1 22:30格式填写，小时、分钟可以省略" textFieldBlock:^(UITextField * _Nonnull textField) {
        textField.text = dateStr;
        
    } sureBlock:^(NSString * _Nullable text) {
        if ([text isEqualToString:dateStr]) {
            return;
        }

        NSDate *beginTime = [SqlEditUtil getEditDate:text];
        NSDate *oldBeginTime = line.beginTime;
        
        line.beginTime = beginTime;
        
        BOOL success = [DataManager updateLine:line];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"修改失败"];
            line.beginTime = oldBeginTime;
        }
    }];
}

- (void)editEndTime:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"确定修改编号%@结束时间吗", line.lineId];
    NSString *dateStr = [SqlEditUtil getDateString:line.endTime prefix:nil placeholder:nil];
    [SCUtilities alertWithTitle:title message:@"请按照2024-10-1格式填写" textFieldBlock:^(UITextField * _Nonnull textField) {
        textField.text = dateStr;
        
    } sureBlock:^(NSString * _Nullable text) {
        if ([text isEqualToString:dateStr]) {
            return;
        }
        
        NSDate *endTime = [SqlEditUtil getEditDate:text];
        NSDate *oldEndTime = line.endTime;
        
        line.endTime = endTime;
        
        BOOL success = [DataManager updateLine:line];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"修改失败"];
            line.endTime = oldEndTime;
        }
    }];
}

- (void)editOverScore:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"修改编号%@当期买法", line.lineId];
    
    [NumberInputView showWithText:line.overScore?:@"" title:title clickView:nil type:InputTypeDefault block:^(NSString * _Nonnull outputText) {
        NSString *oldOverScore = line.overScore;
        
        line.overScore = outputText;
        
        BOOL success = [DataManager updateLine:line];
        
        if (success) {
            [self showWithStatus:@"修改成功"];
            [self.tableView reloadData];
        }else {
            [self showWithStatus:@"修改失败"];
            line.overScore = oldOverScore;
        }
    }];
}

- (void)deleteLine:(LineModel *)line
{
    NSString *title = [NSString stringWithFormat:@"确定要删除编号%@吗", line.lineId];
    [SCUtilities alertWithTitle:title message:@"警告：该操作不可逆" textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        BOOL success = [DataManager deleteLine:line];
        
        if (success) {
            [self showWithStatus:@"删除成功"];
            [self.record.lineList removeObject:line];
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
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
