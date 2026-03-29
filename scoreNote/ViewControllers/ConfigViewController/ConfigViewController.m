//
//  ConfigViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/29.
//

#import "ConfigViewController.h"
#import "ConfigManager.h"
#import "ConfigCalculateCell.h"
#import "ConfigCommonCell.h"
#import "ConfigFunctionCell.h"
#import "BitCoinViewController.h"
#import "SqlEditViewController.h"
#import "ColumnAddViewController.h"

@interface ConfigViewController () <UITableViewDelegate, UITableViewDataSource, ConfigCalculateDelegate, ConfigCommonDelegate, ConfigFunctionDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <ConfigHeaderModel *> *headerList;

@end

@implementation ConfigViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _headerList = [ConfigManager getConfigHeaderList];
    [self.tableView reloadData];
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == ConfigHeaderTypeCalcalte) {
        return 30;
        
    }else {
        return 50;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < _headerList.count) {
        ConfigHeaderModel *model = _headerList[section];
        return model.title;
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _headerList.count) {
        ConfigHeaderModel *model = _headerList[section];
        
        return model.list.count;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ConfigHeaderTypeCalcalte:
            return kCCCellH;
        case ConfigHeaderTypeCommon:
            return kConfigCellH;
        case ConfigHeaderTypeFuction:
            return kCFCellH;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    //双平计算
    if (section == ConfigHeaderTypeCalcalte) {
        ConfigCalculateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCCCellId forIndexPath:indexPath];
        ConfigModel *model = [self getConfigModelAtIndexPath:indexPath];
        if (model) {
            cell.model = model;
            cell.delegate = self;
        }
        
        return cell;
    }
    
    //常用设置
    if (section == ConfigHeaderTypeCommon) {
        ConfigCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigCellId forIndexPath:indexPath];
        ConfigModel *model = [self getConfigModelAtIndexPath:indexPath];
        if (model) {
            cell.model = model;
            cell.delegate = self;
        }
        
        return cell;
    }
    
    //其它功能
    ConfigFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCFCellId forIndexPath:indexPath];
    ConfigModel *model = [self getConfigModelAtIndexPath:indexPath];
    if (model) {
        cell.model = model;
        cell.delegate = self;
    }
    
    return cell;


}

- (ConfigModel *)getConfigModelAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    if (section < _headerList.count) {
        ConfigHeaderModel *headerModel = _headerList[section];
        if (row < headerModel.list.count) {
            ConfigModel *model = headerModel.list[row];
            return model;
        }
    }
    
    return nil;
}

#pragma mark -ConfigCalculateDelegate
- (void)calculateCellEditNumber:(ConfigModel *)model clickView:(UIView *)clickView
{
    [NumberInputView showWithText:model.point title:@"双平计算" clickView:clickView type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        model.point = outputText;
        [ConfigManager doubleDrawCalculate];
        [self.tableView reloadData];
    }];
}

#pragma mark -ConfigCommonDelegate
- (void)commonCellEditValue:(ConfigModel *)model clickView:(UIView *)clickView
{
    NSString *text = model.value == 0 ? @"" : [SCUtilities removeFloatSuffix:model.value];
    
    @weakify(self)
    [NumberInputView showWithText:text title:model.title clickView:clickView type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        model.value = outputText.floatValue;
        [self.tableView reloadData];
    }];
}

- (void)commonCellReset:(ConfigModel *)model
{
    [model resetValue];
    [self.tableView reloadData];
}

- (void)commonCellSwitchChanged:(ConfigModel *)model
{
    model.value = model.value ? 0 : 1;
    [self.tableView reloadData];
}

#pragma mark -ConfigFunctionDelegate
- (void)functionCellPushBitCoin
{
    [self.navigationController pushViewController:[BitCoinViewController new] animated:YES];
}

- (void)functionCellPushDeveloper
{
    if ([ConfigManager isDeveloper]) { //是开发者直接进入
        [self pushDeveloper];
        return;
    }
    //不是开发者要先输密码
    [NumberInputView showWithText:nil title:@"开发者密码" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        BOOL result = [ConfigManager verifyDeveloperPassword:outputText];
        if (result) {
            [self pushDeveloper];
        }else {
            [self showWithStatus:@"密码错误"];
        }
    }];
}

- (void)pushDeveloper
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

- (void)functionCellSaveData
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

- (void)functionCellDeleteData
{
    NSString *filePath = [DataManager sqliteFilePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self showWithStatus:@"暂无数据"];
        
        return;
    }
    
    [SCUtilities alertWithTitle:@"警告" message:@"数据库删除后将无法恢复" textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
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
        [_tableView registerClass:ConfigCalculateCell.class forCellReuseIdentifier:kCCCellId];
        [_tableView registerClass:ConfigCommonCell.class forCellReuseIdentifier:kConfigCellId];
        [_tableView registerClass:ConfigFunctionCell.class forCellReuseIdentifier:kCFCellId];
        _tableView.sectionHeaderTopPadding = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end


