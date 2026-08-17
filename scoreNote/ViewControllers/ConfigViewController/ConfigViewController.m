//
//  ConfigViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/29.
//

#import "ConfigViewController.h"
#import "ConfigViewModel.h"
#import "ConfigCell.h"
#import "SqlEditViewController.h"
#import "ColumnAddViewController.h"
#import "BitCoinViewController.h"


@interface ConfigViewController () <UITableViewDelegate, UITableViewDataSource, ConfigCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ConfigViewModel *viewModel;

@end

@implementation ConfigViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"设置";
    [self tableView];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.sectionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //无实际意义，仅做间隔用
    UIView *footer = [UIView new];
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.viewModel.sectionList.count) {
        ConfigSectionModel *sectioinModel = self.viewModel.sectionList[section];
        return sectioinModel.models.count;
        
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigCellId forIndexPath:indexPath];
    
    if (indexPath.section < self.viewModel.sectionList.count) {
        ConfigSectionModel *sectionModel = self.viewModel.sectionList[indexPath.section];
        [cell update:sectionModel index:indexPath.row];
        cell.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.viewModel.sectionList.count) {
        return;
    }
    
    ConfigSectionModel *sectionModel = self.viewModel.sectionList[indexPath.section];
    
    if (indexPath.row >= sectionModel.models.count) {
        return;
    }
    
    ConfigModel *model = sectionModel.models[indexPath.row];
    
    
    switch (model.type) {
        case ConfigTypeLineProfit:  //每期利润
        case ConfigTypeBaseProfit:  //固定利润
        case ConfigTypeBreakLine:   //止损线
        case ConfigTypeInputH:      //键盘高度
        {
            [self editValueAction:model];
        }
            break;
        case ConfigTypeDeveloper:
        {
            [self pushDeveloperAction];
        }
            break;
        case ConfigTypeBitCoin:
        {
            [self pushBitCoinAction];
        }
            break;
        case ConfigTypeDataBase:
        {
            [self dataBaseAction];
        }
            break;
        default:
            break;
    }
    //ConfigTypeIsSporttery  带switch开关的只能点击右边一小块区域，走代理
    //ConfigTypeDataVersion ConfigTypeAppVersion 无点击事件
}

#pragma mark -更改各项数值
- (void)editValueAction:(ConfigModel *)model
{
    [NumberInputView showWithText:model.content title:model.title clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        model.content = outputText;
        [self.tableView reloadData];
    }];
}

#pragma mark -开发者功能
- (void)pushDeveloperAction
{
    if (self.viewModel.isDeveloper) { //是开发者直接进入
        [self selectDeveloperViewController];
        return;
    }
    
    //不是开发者要先输密码
    [NumberInputView showWithText:nil title:@"开发者密码" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        if (outputText.length <= 0) {
            return;
        }
        BOOL result = [self.viewModel verifyDeveloperPassword:outputText];
        if (result) {
            [self selectDeveloperViewController];
        }else {
            [self showWithStatus:@"密码错误"];
        }
    }];
}

- (void)selectDeveloperViewController
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [ac addAction:[UIAlertAction actionWithTitle:@"修改数据库数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[SqlEditViewController new] animated:YES];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"增加数据库字段" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[ColumnAddViewController new] animated:YES];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark -比特币账本
- (void)pushBitCoinAction
{
    [self.navigationController pushViewController:[BitCoinViewController new] animated:YES];
}

#pragma mark -数据库
- (void)dataBaseAction
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [ac addAction:[UIAlertAction actionWithTitle:@"备份数据库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveDataAction];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"清除数据库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearDataAction];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:ac animated:YES completion:nil];
}

- (void)saveDataAction
{
    NSString *filePath = [DataManager sqliteFilePath];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray*activityItems =@[fileData, fileURL];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
        
    };
}

- (void)clearDataAction
{
    NSString *filePath = [DataManager sqliteFilePath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self showWithStatus:@"暂无数据"];

        return;
    }

    [SCUtilities alertWithTitle:@"警告" message:@"数据清除后将无法恢复" textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (result && !error) {
            [self showWithStatus:@"删除成功"];
            [DataManager clear];
        }else {
            [self showWithStatus:@"删除失败"];
        }
    }];
}

#pragma mark -ConfigCellDelegate 开关
- (void)configCellSwitchClicked:(ConfigModel *)model
{
    BOOL on = model.content.floatValue;
    
    model.content = [NSString stringWithFormat:@"%i", !on];
    [self.tableView reloadData];
}


#pragma mark -UI
- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT;
        if (@available(iOS 26.0, *)) {
            //ios26不减导航栏高度，否则会出错，原因未知 tabbar高度可减可不减。减了底部正好在tabbar上方，不减和毛玻璃效果适配'
            //            h = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
            h = SCREEN_HEIGHT; //这里不减，视觉效果最好
        }
        
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = DEFAULT_BG_COLOR;
        _tableView.sectionHeaderTopPadding = 0;
        _tableView.rowHeight = kConfigCellH;
        [_tableView registerClass:ConfigCell.class forCellReuseIdentifier:kConfigCellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (ConfigViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [ConfigViewModel new];
    }
    return _viewModel;
}
@end


