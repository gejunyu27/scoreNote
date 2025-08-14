//
//  RecordView.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/30.
//

#import "RecordView.h"
#import "LineCell.h"
#import "DataManager.h"
#import "SCToolBar.h"

#define kLineCell @"LineCell"
#define kDefaulScore @"添加本期买法"

@interface RecordView () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;

@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;
@property (weak, nonatomic) IBOutlet UILabel *planGetLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *planProfitLabel;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *lastLostButton;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;


@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UILabel *baseProfitLabel;


@property (nonatomic, strong) RecordModel *model;
@property (nonatomic, assign) NSInteger maxNum;
@end

@implementation RecordView

- (instancetype)init
{
    self = [[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:self options:nil].firstObject;
    if (!self) {
        self = [super init];
    }
    
    [_tableView registerNib:[UINib nibWithNibName:kLineCell bundle:nil] forCellReuseIdentifier:kLineCell];
    
    [SCToolBar addNoteBarInTextView:_noteTextView];
    
    _numberButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
    
    return self;
}

- (void)refreshUI:(RecordModel *)model title:(nonnull NSString *)title maxNum:(NSInteger)maxNum
{
    _model = model;
    _maxNum = maxNum;
    
    self.width = LINE_WIDTH;
    self.height = LINE_HEIGHT* (1+maxNum+1)+_bottomH.constant;
    
    //标题
    _titleLabel.text = title;
    _titleH.constant = LINE_HEIGHT;
    _titleLabel.font = LINE_FONT;
    
    //列表
    [_tableView reloadData];
    
    //当前利润
    _profitLabel.text = [SCUtilities removeFloatSuffix:model.allProfit];
    _profitLabel.font = LINE_FONT;
    
    //期数
    NSInteger count = model.lineList.count;
    _countLabel.text = [NSString stringWithFormat:@"%li", count];
    _countLabel.font = LINE_FONT;
    
    //利润
    CGFloat planProfit = (count+1) * model.profitPerLine + model.baseProfit;
    _planProfitLabel.text = [SCUtilities removeFloatSuffix:planProfit];
    _planProfitLabel.font = LINE_FONT;
    
    //应收
    CGFloat planGet = MAX(planProfit - _model.allProfit, 0) ;
    _planGetLabel.text = [SCUtilities removeFloatSuffix:planGet];
    _planGetLabel.font = LINE_FONT;
    
    //固定利润
    _baseProfitLabel.text = model.baseProfit <= 0 ? @"" : [SCUtilities removeFloatSuffix:model.baseProfit];
    
    //标签
    _tagLabel.text = _model.tagModel ? _model.tagModel.name : @"无";
    
    //实际期数
    [_numberButton setTitle:[NSString stringWithFormat:@"%li", _model.realNum] forState:UIControlStateNormal];
    
    //当期买法
    [_scoreButton setTitle:(model.currentScore.length == 0 ? kDefaulScore : model.currentScore) forState:UIControlStateNormal];
    
    //笔记
    _noteTextView.text = model.note;
    
    //未中按钮
    BOOL lastIsOver = _model.lineList.count == 0 || _model.lineList.lastObject.isOver;
    [_lastLostButton setTitleColor:lastIsOver?[UIColor grayColor]:[UIColor systemBlueColor] forState:UIControlStateNormal];
    _lastLostButton.userInteractionEnabled = !lastIsOver;
    
    //买过的单子 标绿提醒 到第二天6点前消失
    BOOL isBuyToday = NO;
    if (model.lineList.count > 0) {
        LineModel *lastModel = model.lineList.lastObject;
        if (!lastModel.isOver) { //最后一个没结束
            NSDate *buyDate = lastModel.beginTime;
            NSDate *today   = [NSDate date];
            
            NSInteger days = [today daysBetweenDate:buyDate];
            
            if (days == 0) {
                isBuyToday = YES;
                
            }else if (days == 1) { //已经不是同一天，查看是不是第二天早上6点前
                NSInteger hour = [today getStringWithDateFormat:@"HH"].integerValue;
                if (hour < 6) {
                    isBuyToday = YES;
                }
            }
        }
    }
    
    _noteTextView.layer.borderColor = isBuyToday ? [UIColor colorWithHex:@"#49AB58"].CGColor : [UIColor blackColor].CGColor;
}

- (void)refreshUI
{
    [self refreshUI:self.model title:self.titleLabel.text maxNum:self.maxNum];
}

#pragma -mark

- (IBAction)overAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordView:overRecord:)]) {
        [self.delegate recordView:self overRecord:self.model];
    }
    
}

- (IBAction)editAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordView:editRecord:)]) {
        [self.delegate recordView:self editRecord:self.model];
    }
}

- (IBAction)lineLoseAction:(id)sender {
    if (self.model.lineList.count <= 0) {
        return;
    }
    
    //全部结束
    for (LineModel *line in self.model.lineList) {
        if (!line.isOver) {
            line.getMoney = 0;
            line.isOver = YES;
            [DataManager updateLine:line];
            
        }
    }
    
    //移除买法
    _model.currentScore = @"";
    [DataManager updateRecord:_model];
    
    //刷新
    [self refreshUI:_model title:_titleLabel.text maxNum:_maxNum];
    
}

- (IBAction)tagAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordView:tagSelect:)]) {
        [self.delegate recordView:self tagSelect:self.model];
    }
}

- (IBAction)numAddAction:(UIButton *)sender {
    NSInteger num = _numberButton.titleLabel.text.integerValue;
    num++;
    [_numberButton setTitle:[NSString stringWithFormat:@"%li",num] forState:UIControlStateNormal];
    _model.realNum = num;
    [self editRealNum];
}

- (IBAction)scoreAction:(UIButton *)sender {
    NSString *text = [sender.titleLabel.text isEqualToString:kDefaulScore]?@"":sender.titleLabel.text;
    @weakify(self)
    [NumberInputView showWithText:text title:@"编辑买法" clickView:sender type:InputTypeDefault block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        [sender setTitle:(outputText.length == 0 ? kDefaulScore : outputText) forState:UIControlStateNormal];
        
        self.model.currentScore = outputText;
        [DataManager updateRecord:self.model];
    }];
    
}

- (IBAction)numberEditAction:(UIButton *)sender {
    NSString *text = [sender.titleLabel.text isEqualToString:@"0"] ? @"" : sender.titleLabel.text;
    @weakify(self)
    [NumberInputView showWithText:text title:@"编辑实际期数" clickView:sender type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        NSString *string = outputText.length == 0 ? @"0" : outputText;
        [sender setTitle:string forState:UIControlStateNormal];
        
        NSInteger num = [string integerValue];
        self.model.realNum = num;
        [self editRealNum];
        
    }];
}

- (void)editRealNum
{
    if ([self.delegate respondsToSelector:@selector(recordView:editRealNum:)]) {
        [self.delegate recordView:self editRealNum:self.model];
    }
}

- (IBAction)quickBuyAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(recordView:insertNewLineWithRecord:view:)]) {
        [self.delegate recordView:self insertNewLineWithRecord:self.model view:nil];
    }
}



#pragma mark -UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LINE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _maxNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    
    LineCell *cell = [tableView dequeueReusableCellWithIdentifier:kLineCell];
    
    LineModel *lineModel = row < _model.lineList.count ? _model.lineList[row] : nil;
    cell.model = lineModel;
    cell.isFirst = !row;
    cell.canAdd = row == _model.lineList.count;
    
    @weakify(self)
    cell.updateBlock = ^(LineModel * _Nonnull line) {
        @strongify(self)
        [self refreshUI:self.model title:self.titleLabel.text maxNum:self.maxNum];
    };
    
    cell.addBlock = ^(UIView * _Nonnull view) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(recordView:insertNewLineWithRecord:view:)]) {
            [self.delegate recordView:self insertNewLineWithRecord:self.model view:view];
        }
    };
    
    return cell;
    
    
}


#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(recordView:editNote:record:)]) {
        [self.delegate recordView:self editNote:textView.text record:self.model];
    }
    
}

@end
