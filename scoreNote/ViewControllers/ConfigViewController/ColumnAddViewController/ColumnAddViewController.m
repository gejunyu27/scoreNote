//
//  ColumnAddViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/7.
//

#import "ColumnAddViewController.h"
#import "ColumnManager.h"

@interface ColumnAddViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *tableSegment;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UISwitch *notnullSwitch;

@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation ColumnAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"增加数据库字段";
    
    //表名设置
    [_tableSegment setTitle:[DataManager recordTableName] forSegmentAtIndex:0];
    [_tableSegment setTitle:[DataManager lineTableName] forSegmentAtIndex:1];
    [_tableSegment setTitle:[DataManager tagTableName] forSegmentAtIndex:2];
    
    [self tableSegmentValueChanged:_tableSegment];
}

#pragma mark -action
- (IBAction)tableSegmentValueChanged:(UISegmentedControl *)sender {
    
    _tableLabel.text = [NSString stringWithFormat:@"表格“%@”所有字段：", [self currentTableName]];
    
    [_tableView reloadData];
    
}

- (NSString *)currentTableName
{
    NSString *selectedTitle = [_tableSegment titleForSegmentAtIndex:_tableSegment.selectedSegmentIndex];
    return selectedTitle;
}

- (NSArray <ColumnModel *> *)currentColumns
{
    NSArray *arr = self.data[self.currentTableName];
    
    return arr;
}


- (IBAction)notnullSwitchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [self showWithStatus:@"暂时停止非空属性添加"];
        [sender setOn:NO animated:YES];
    }

}

- (IBAction)commitAction:(UIButton *)sender {
    [self resignFirstResponder];
    
    NSString *name = _nameTF.text;
    
    if (!VALID_STRING(name)) {
        [self showWithStatus:@"不能为空"];
        return;
    }
    
    NSString *type = [_typeSegment titleForSegmentAtIndex:_typeSegment.selectedSegmentIndex];
    
    
    BOOL success = [ColumnManager addNewColumnWithName:name type:type notnull:_notnullSwitch.isOn table:[self currentTableName]];
    
    if (success) {
        [self showWithStatus:@"添加成功"];
        _nameTF.text = nil;
        _data = nil;
        [self.tableView reloadData];
        
    }else {
        [self showWithStatus:@"添加失败"];
    }
    
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentColumns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger row = indexPath.row;
    if (row < self.currentColumns.count) {
        ColumnModel *column = self.currentColumns[row];
        cell.textLabel.text = [NSString stringWithFormat:@"%li. %@",row+1, column.name];
        cell.detailTextLabel.text = column.descriptionRemoveName;
    }
    
    return cell;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

#pragma mark -data
- (NSDictionary *)data
{
    if (!_data) {
        NSString *record = [DataManager recordTableName];
        NSArray *recordColumns = [ColumnManager queryAllColumnsFromTable:record];
        
        NSString *line = [DataManager lineTableName];
        NSArray *lineColumns = [ColumnManager queryAllColumnsFromTable:line];
        
        NSString *tag = [DataManager tagTableName];
        NSArray *tagColumns = [ColumnManager queryAllColumnsFromTable:tag];
        
        _data = @{record:recordColumns,
                  line:lineColumns,
                  tag:tagColumns};
        
        
    }
    return _data;
}

@end
