//
//  HomeViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "RecordManager.h"
#import "TagSelectView.h"
#import "RecordDetailViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, HomeCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) NSMutableArray <RecordModel *> *records;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ui
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    [self refreshUI];

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

- (void)homeCellEditRealNum:(RecordModel *)record
{
    @weakify(self)
    NSString *text = record.realNum ? [NSString stringWithFormat:@"%li", record.realNum] : @"";
    [NumberInputView showWithText:text title:@"编辑实际期数" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        NSInteger realNum = MAX(outputText.integerValue, 0);
        BOOL result = [RecordManager editRealNum:realNum record:record];
        [self refreshTableViewWithResult:result];
        
    }];
    
}

- (void)homeCellEditScore:(RecordModel *)record
{
    @weakify(self)
    [NumberInputView showWithText:record.currentScore title:@"编辑买法" clickView:nil type:InputTypeDefault block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editCurrentScore:outputText record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellBuy:(RecordModel *)record
{
    [NumberInputView showWithText:nil title:@"输入投入额" clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        CGFloat outmoney = VALID_STRING(outputText) ? outputText.floatValue : 0;
        if (outmoney <= 0) {
            return;
        }
        
        BOOL result = [RecordManager addNewLine:record outMoney:outmoney];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellShowDetails:(RecordModel *)record
{
    RecordDetailViewController *vc = [RecordDetailViewController new];
    [vc setRecord:record canEdit:YES];
    @weakify(self)
    vc.updateBlock = ^{
      @strongify(self)
        [self.tableView reloadData];
    };
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

- (void)homeCellBuyWin:(RecordModel *)record
{
    @weakify(self)
    [NumberInputView showWithText:@"" title:@"利润" clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
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

//- (void)homeCellEditNote:(NSString *)note record:(RecordModel *)record
//{
//    BOOL result = [RecordManager editNote:note record:record];
//    if (!result) {
//        [self showWithStatus:@"修改失败"];
//    }
//}


#pragma mark -action
- (void)addClick
{
    [TagSelectView show:^(TagModel * _Nullable tag) {
        BOOL result = [RecordManager addNewRecord:tag.tagId];
        [self refreshTableViewWithResult:result];
        
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
        _tableView.rowHeight = kHomeCellH;
        [_tableView registerClass:HomeCell.class forCellReuseIdentifier:kHomeCellId];
        _tableView.backgroundColor = HEX_RGB(@"#F8F9FE");
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
