//
//  RecordDetailViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/21.
//

#import "RecordDetailViewController.h"
#import "RecordDetailCell.h"
#import "RecordManager.h"
#import "SCToolBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecordDetailCellDelegate>
@property (nonatomic, strong) RecordModel *record;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *noteField;
@property (nonatomic, strong) UIButton *perProfitButton;
@property (nonatomic, strong) UIButton *baseProfitButton;
@property (nonatomic, strong) UIButton *breakLineButton;

@property (nonatomic, assign) BOOL hasUpdated;
@end

@implementation RecordDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_hasUpdated && self.updateBlock) {
        self.updateBlock();
    }
}

#pragma mark -data
- (void)setRecord:(RecordModel *)record canEdit:(BOOL)canEdit
{
    _record  = record;
    _canEdit = canEdit && !record.isOver; //双重保险 目前只有在首页点击在投单子详情进入的，才能编
    
    [self updateData:YES];
}

- (void)updateData:(BOOL)refreshTable
{
    if (refreshTable) {
        [self.tableView reloadData];
    }
    
    //是否可编辑
    _topView.userInteractionEnabled = _canEdit;
    
    //标题
    self.title = _record.tagModel ? _record.tagModel.name : @"详情";
    
    CGFloat allGet = _record.allGet;
    CGFloat allOut = _record.allOut;
    CGFloat profit = allGet - allOut;
    
    //利润
    NSString *profitStr = [SCUtilities removeFloatSuffix:profit];
    NSString *profitText = [NSString stringWithFormat:@"利润：%@",profitStr];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:profitText];
    [att addAttributes:@{NSForegroundColorAttributeName:(profit>0?[UIColor redColor]:[UIColor blackColor])} range:[profitText rangeOfString:profitStr]];
    _profitLabel.attributedText = att;
    
    //支出收入
    _detailLabel.text = [NSString stringWithFormat:@"共%li期，投入%li单%@元，收入%@元", _record.realNum, _record.lineList.count, [SCUtilities removeFloatSuffix:allOut], [SCUtilities removeFloatSuffix:allGet]];
    
    //笔记
    _noteField.text = _record.note;
    if (_record.note.length == 0) {
        _noteField.placeholder = _canEdit ? @"点击输入笔记" : @"无";
    }
    
    //每期利润
    [_perProfitButton setTitle:[NSString stringWithFormat:@"每期利润%@元", [SCUtilities removeFloatSuffix:_record.profitPerLine]] forState: UIControlStateNormal];
    
    //固定利润
    [_baseProfitButton setTitle:[NSString stringWithFormat:@"固定利润%@元", [SCUtilities removeFloatSuffix:_record.baseProfit]] forState: UIControlStateNormal];
    
    //止损线
    [_breakLineButton setTitle:[NSString stringWithFormat:@"止损线%@元", [SCUtilities removeFloatSuffix:_record.breakLine]] forState: UIControlStateNormal];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _record.lineList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kRDCellId forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (row < _record.lineList.count) {
        LineModel *line = _record.lineList[row];
        [cell setLine:line row:row canEdit:_canEdit];
        cell.delegate = self;
    }
    
    return cell;
}

//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [SCUtilities alertWithTitle:@"确定要删除吗" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
            NSInteger row = indexPath.row;
            if (row < self.record.lineList.count) {
                LineModel *line = self.record.lineList[row];
                BOOL result = [RecordManager deleteLine:line];
                [self handleEditResult:result refreshTable:YES];
            }
        }];
        

        
    }
}


#pragma mark -RecordDetailCellDelegate
- (void)recordDetailCellEditOutMoney:(LineModel *)line clickView:(UIView *)clickView
{
    NSString *text = line.outMoney > 0 ? [SCUtilities removeFloatSuffix:line.outMoney] : @"";
    [NumberInputView showWithText:text title:@"输入投入额" clickView:clickView type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        CGFloat outmoney = VALID_STRING(outputText) ? outputText.floatValue : 0;

        BOOL result = [RecordManager editLineOutMoney:outmoney line:line];
        
        [self handleEditResult:result refreshTable:YES];
    }];
}

- (void)recordDetailCellEditGetMoney:(LineModel *)line clickView:(UIView *)clickView
{
    NSString *text = line.getMoney > 0 ? [SCUtilities removeFloatSuffix:line.getMoney] : @"";
    [NumberInputView showWithText:text title:@"输入收入额" clickView:clickView type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        CGFloat getmoney = VALID_STRING(outputText) ? outputText.floatValue : 0;
        
        BOOL result = [RecordManager editLineGetMoney:getmoney line:line];
        
        [self handleEditResult:result refreshTable:YES];
    }];
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:_record.note]) { //无变化
        return;
    }
    
    BOOL result = [RecordManager editNote:textField.text record:_record];
    [self handleEditResult:result refreshTable:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -action
- (void)selectClicked
{
    
}

- (void)perProfitClicked:(UIButton *)sender
{
    NSString *text = _record.profitPerLine ? [SCUtilities removeFloatSuffix:_record.profitPerLine] : @"";
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改每期利润" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editProfitPerLine:outputText.floatValue record:self.record];
        [self handleEditResult:result refreshTable:NO];
    }];
}

- (void)baseProfitClicked:(UIButton *)sender
{
    NSString *text = _record.baseProfit ? [SCUtilities removeFloatSuffix:_record.baseProfit] : @"" ;
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改固定利润" clickView:nil type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editBaseProfit:outputText.floatValue record:self.record];
        [self handleEditResult:result refreshTable:NO];
    }];
}

- (void)breakLineClicked:(UIButton *)sender
{
    NSString *text = _record.breakLine ? [SCUtilities removeFloatSuffix:_record.breakLine] : @"";
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改止损线" clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editBreakLine:outputText.floatValue record:self.record];
        [self handleEditResult:result refreshTable:NO];
    }];
}

- (void)handleEditResult:(BOOL)result refreshTable:(BOOL)refreshTable
{
    if (result) {
        _hasUpdated = YES;
        [self updateData:refreshTable];
        
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
        _tableView.rowHeight = kRDCellH;
        [_tableView registerClass:RecordDetailCell.class forCellReuseIdentifier:kRDCellId];
        _tableView.backgroundColor = DEFAULT_BG_COLOR;
        _tableView.tableHeaderView = self.topView;
        _tableView.sectionHeaderTopPadding = 0;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        
        //背景框
        CGFloat margin = 15;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, _topView.width-margin*2, _topView.height-5)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 10;
        [bgView setCommonShadow];
        [_topView addSubview:bgView];
        
        //利润
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 5, 120, 30)];
        _profitLabel.font = SCFONT_SIZED(17);
        [bgView addSubview:_profitLabel];
        
        //详情
        CGFloat detailX = _profitLabel.right+2;
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailX, _profitLabel.top, bgView.width-detailX-margin, _profitLabel.height)];
        _detailLabel.font = SCFONT_SIZED(10);
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = [UIColor grayColor];
        [bgView addSubview:_detailLabel];
        
        //笔记
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, _profitLabel.bottom+10, 50, 20)];
        noteLabel.font = _profitLabel.font;
        noteLabel.text = @"笔记：";
        [bgView addSubview:noteLabel];
        CGFloat noteX = noteLabel.right;
        _noteField = [[UITextField alloc] initWithFrame:CGRectMake(noteX, 0, bgView.width-margin-noteX, 22)];
        _noteField.centerY = noteLabel.centerY;
        _noteField.font = SCFONT_SIZED(13);
        _noteField.borderStyle = UITextBorderStyleRoundedRect;
        _noteField.returnKeyType = UIReturnKeyDone;
        _noteField.delegate = self;
        [SCToolBar addNoteBarInTextField:_noteField];
        [bgView addSubview:_noteField];
        
        CGFloat btnW = (bgView.width - margin*4)/3;
        CGFloat btnY = noteLabel.bottom+15;
        CGFloat btnH = bgView.height - btnY - 10;
        
        for (int i=0; i<3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(margin+(btnW+margin)*i, btnY, btnW, btnH)];
            btn.backgroundColor = HEX_RGB(@"#4792F7");
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = SCFONT_SIZED(11);
            btn.layer.cornerRadius = 5;
            [bgView addSubview:btn];
            
            if (i==0) {
                _perProfitButton = btn;
                [_perProfitButton addTarget:self action:@selector(perProfitClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (i==1) {
                _baseProfitButton = btn;
                [_baseProfitButton addTarget:self action:@selector(baseProfitClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (i==2) {
                _breakLineButton = btn;
                [_breakLineButton addTarget:self action:@selector(breakLineClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return _topView;
}

@end

NS_ASSUME_NONNULL_END
