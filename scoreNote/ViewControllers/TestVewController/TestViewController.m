//
//  TestViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import "TestViewController.h"
#import "HomeCell.h"
#import "RecordManager.h"
#import "TagSelectView.h"
#import "RecordDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource, HomeCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) NSMutableArray <RecordModel *> *records;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新ui
    [self refreshUI];
    
    //添加键盘监控
    [self addKeyboardNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([RecordManager sharedInstance].needUpdate) {
        [self refreshUI];
        [RecordManager sharedInstance].needUpdate = NO;
    }
}

- (void)refreshUI
{
    //获取首页展示记录
    _records = [RecordManager homeRecords];
    
    [self.tableView reloadData];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeCellId forIndexPath:indexPath];
    cell.delegate = self;
    
    if (indexPath.row < _records.count) {
        RecordModel *record = _records[indexPath.row];
        cell.record = record;
    }
    
    return cell;
}

#pragma mark -HomeCellDelegate
- (void)homeCellTagSelect:(RecordModel *)record
{
    [TagSelectView show:^(TagModel * _Nullable tag) {
        BOOL result = [RecordManager editTag:(tag ? tag.tagId : 0) record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellEditRealNum:(RecordModel *)record clickView:(nonnull UIView *)clickView
{
    @weakify(self)
    NSString *text = record.realNum ? [NSString stringWithFormat:@"%li", record.realNum] : @"";
    [NumberInputView showWithText:text title:@"编辑实际期数" clickView:clickView type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        [self updateNewRealNum:[outputText integerValue] record:record];
        
    }];
    
}

- (void)homeCellAddRealNum:(RecordModel *)record
{
    [self updateNewRealNum:record.realNum+1 record:record];
}

- (void)updateNewRealNum:(NSInteger)realNum record:(RecordModel *)record
{
    BOOL result = [RecordManager editRealNum:MAX(realNum, 0) record:record];
    [self refreshTableViewWithResult:result];
}

- (void)homeCellEditScore:(RecordModel *)record clickView:(nonnull UIView *)clickView
{
    @weakify(self)
    [NumberInputView showWithText:record.currentScore title:@"编辑买法" clickView:clickView type:InputTypeDefault block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editCurrentScore:outputText record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellEditBreakLine:(RecordModel *)record clickView:(nonnull UIView *)clickView
{
    NSString *text = record.breakLine ? [SCUtilities removeFloatSuffix:record.breakLine] : @"";
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改止损线" clickView:clickView type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editBreakLine:outputText.floatValue record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellEditProfitPerLine:(RecordModel *)record clickView:(UIView *)clickView
{
    if (record.isBreaking) {
        [self showWithStatus:@"止损中 无法修改"];
        return;
    }
    
    NSString *text = record.profitPerLine ? [SCUtilities removeFloatSuffix:record.profitPerLine] : @"";
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改每期利润" clickView:clickView type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editProfitPerLine:outputText.floatValue record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellEditBaseProfit:(RecordModel *)record clickView:(UIView *)clickView
{
    if (record.isBreaking) {
        [self showWithStatus:@"止损中 无法修改"];
        return;
    }
    
    NSString *text = record.baseProfit ? [SCUtilities removeFloatSuffix:record.baseProfit] : @"" ;
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改固定利润" clickView:clickView type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editBaseProfit:outputText.floatValue record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellEditNote:(NSString *)note record:(RecordModel *)record
{
    BOOL result = [RecordManager editNote:note record:record];
    if (!result) {
        [self showWithStatus:@"修改失败"];
    }
}

- (void)homeCellBuy:(RecordModel *)record clickView:(UIView *)clickView
{
    [NumberInputView showWithText:nil title:@"输入投入额" clickView:clickView type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        CGFloat outmoney = VALID_STRING(outputText) ? outputText.floatValue : 0;
        if (outmoney <= 0) {
            return;
        }
        
        BOOL result = [RecordManager addNewLine:record outMoney:outmoney];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellShowLines:(RecordModel *)record
{
    RecordDetailViewController *vc = [RecordDetailViewController new];
    vc.model = record;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeCellOverRecord:(RecordModel *)record
{
    if (!record || record.lineList.count == 0) {
        [self showWithStatus:@"无购买记录"];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"确定要结束%@吗", record.tagModel.name];
    
    [SCUtilities alertWithTitle:title message:nil textFieldBlock:nil sureBlock:^(NSString * _Nonnull text) {
        BOOL result = [RecordManager closeRecord:record];
        [self refreshTableViewWithResult:result];
    }];
  
}

- (void)homeCellBuyLose:(RecordModel *)record
{
    BOOL result = [RecordManager lastLineLose:record];
    [self refreshTableViewWithResult:result];
    
}

- (void)homeCellBuyWin:(RecordModel *)record clickView:(UIView *)clickView
{
    @weakify(self)
    [NumberInputView showWithText:@"" title:@"利润" clickView:clickView type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        if (outputText.length == 0) {
            return;
        }
        
        CGFloat profit = outputText.floatValue;
        
        BOOL result = [RecordManager lastLineWin:profit record:record];
        
        [self refreshTableViewWithResult:result];

    }];
}

- (void)refreshTableViewWithResult:(BOOL)result
{
    if (result) {
        [self.tableView reloadData];
        
    }else {
        [self showWithStatus:@"修改失败"];
    }
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
        _tableView.rowHeight = kHomeCellH;
        [_tableView registerClass:HomeCell.class forCellReuseIdentifier:kHomeCellId];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

NS_ASSUME_NONNULL_END
