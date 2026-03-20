//
//  HomeCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import "HomeCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *tagView;               //标签区
@property (nonatomic, strong) UIButton *tagSelectButton;       //标签名
@property (nonatomic, strong) UIButton *realNumButton;       //标签实际期数
@property (nonatomic, strong) UIButton *scoreButton;         //买法按钮

@property (nonatomic, strong) UIView *recordView;            //记录区
@property (nonatomic, strong) UILabel *profitLabel;          //利润
@property (nonatomic, strong) UIButton *breakLineButton;     //止损
@property (nonatomic, strong) UILabel *buyNumLabel;          //已跟期数
@property (nonatomic, strong) UIButton *perProfitButton;     //每期利润
@property (nonatomic, strong) UIButton *baseProfitButton;    //固定利润
@property (nonatomic, strong) UILabel *planProfitLabel;      //总计利润
@property (nonatomic, strong) UILabel *planGetLabel;         //预期获得

@property (nonatomic, strong) UITextField *noteField;        //笔记

@property (nonatomic, strong) UIView *buyView;               //购买区
@property (nonatomic, strong) UIButton *buyButton;           //立即购买
@property (nonatomic, strong) UILabel *boughtLabel;          //购买内容
@property (nonatomic, strong) UIButton *winButton;           //中奖按钮
@property (nonatomic, strong) UIButton *loseButton;          //未中按钮

@property (nonatomic, strong) UIButton *linesButton;         //详情按钮
@property (nonatomic, strong) UIButton *overButton;          //结束按钮


@property (nonatomic, strong) UIView *line;                 //分割线

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self overButton];
    }
    return self;
}

#pragma mark -data
- (void)setRecord:(RecordModel *)record
{
    _record = record;
    
    //标签
    [_tagSelectButton setTitle:(_record.tagModel ? _record.tagModel.name : @"无跟单") forState:UIControlStateNormal];
    
    //实际期数
    [_realNumButton setTitle:[NSString stringWithFormat:@"%li", _record.realNum] forState:UIControlStateNormal];
    
    //本期买法
    [_scoreButton setTitle:(record.currentScore.length == 0 ? @"添加本期买法" : record.currentScore) forState:UIControlStateNormal];
    
    //笔记
    _noteField.text = record.note;
    
    //当前利润
    CGFloat allProfit = record.allProfit;
    _profitLabel.text = [NSString stringWithFormat:@"当前利润：%@", [SCUtilities removeFloatSuffix:allProfit]];
    
    //止损线
    [_breakLineButton setTitle:[NSString stringWithFormat:@"止损线%@", [SCUtilities removeFloatSuffix:record.breakLine]] forState:UIControlStateNormal];
    
    //已跟期数
    NSInteger count = record.lineList.count;
    _buyNumLabel.text = [NSString stringWithFormat:@"已跟%li期", count];
    
    //计划利润
    CGFloat planProfit = (count+1)*record.profitPerLine + record.baseProfit;
    _planProfitLabel.text = [NSString stringWithFormat:@"计划利润：%@",[SCUtilities removeFloatSuffix:planProfit]];
    
    //每期利润
    [_perProfitButton setTitle:[SCUtilities removeFloatSuffix:record.profitPerLine] forState:UIControlStateNormal];
    
    //固定利润
    [_baseProfitButton setTitle:[SCUtilities removeFloatSuffix:record.baseProfit] forState:UIControlStateNormal];
    
    //本次投注所需利润
    if (record.isBreaking) { //需要止损
        _profitLabel.textColor = [UIColor redColor];
        _planGetLabel.textColor = [UIColor redColor];
        _planGetLabel.text = @"建议止损或保本";
        
    }else {
        _profitLabel.textColor = [UIColor blackColor];
        _planGetLabel.textColor = [UIColor blackColor];
        
        CGFloat planGet = MAX(planProfit - allProfit, 0);
        _planGetLabel.text  = [NSString stringWithFormat:@"本次投注所需利润：%@", [SCUtilities removeFloatSuffix:planGet]];
        
    }
    
    //购买按钮样式
    BOOL isBought = record.lineList.count > 0 && !record.lineList.lastObject.isOver;  //购买过
    _buyView.layer.borderColor = [UIColor blackColor].CGColor;
    if (isBought) {
        _buyButton.hidden = YES;
        _boughtLabel.text = [NSString stringWithFormat:@"本次购买：%@",[SCUtilities removeFloatSuffix:record.lineList.lastObject.outMoney]];
        
    }else {
        _buyButton.hidden = NO;
    }
    
    //买过的单子 标绿提醒 到第二天6点前消失
    BOOL isBuyToday = NO;
    if (record.lineList.count > 0) {
        LineModel *lastModel = record.lineList.lastObject;
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
    _buyView.layer.borderColor = isBuyToday ? HEX_RGB(@"#49AB58").CGColor : [UIColor blackColor].CGColor;
}

#pragma mark -action
- (void)tagSelectClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellTagSelect:)]) {
        [self.delegate homeCellTagSelect:_record];
    }
}

- (void)realNumClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditRealNum:clickView:)]) {
        [self.delegate homeCellEditRealNum:_record clickView:sender];
    }
}

- (void)numAddClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellAddRealNum:)]) {
        [self.delegate homeCellAddRealNum:_record];
    }
}

- (void)scoreClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditScore:clickView:)]) {
        [self.delegate homeCellEditScore:_record clickView:sender];
    }
}

- (void)breakLineClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditBreakLine:clickView:)]) {
        [self.delegate homeCellEditBreakLine:_record clickView:sender];
    }
}

- (void)perProfitClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditProfitPerLine:clickView:)]) {
        [self.delegate homeCellEditProfitPerLine:_record clickView:sender];
    }
}

- (void)baseProfitClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditBaseProfit:clickView:)]) {
        [self.delegate homeCellEditBaseProfit:_record clickView:sender];
    }
}

- (void)buyClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellBuy:clickView:)]) {
        [self.delegate homeCellBuy:_record clickView:sender];
    }
}

- (void)linesClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellShowLines:)]) {
        [self.delegate homeCellShowLines:_record];
    }
}

- (void)overClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellOverRecord:)]) {
        [self.delegate homeCellOverRecord:_record];
    }
}

- (void)loseClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellBuyLose:)]) {
        [self.delegate homeCellBuyLose:_record];
    }
}

- (void)winClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellBuyWin:clickView:)]) {
        [self.delegate homeCellBuyWin:_record clickView:sender];
    }
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditNote:record:)]) {
        [self.delegate homeCellEditNote:textField.text record:_record];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -ui
#define kMargin 10

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, SCREEN_WIDTH/4, 95)];
        [self.contentView addSubview:_tagView];
        
        //单子
        UIColor *tagColor = [UIColor blueColor];
        _tagSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _tagView.width, 25)];
        [_tagSelectButton setTitleColor:tagColor forState:UIControlStateNormal];
        _tagSelectButton.titleLabel.font = SCFONT_SIZED(12);
        _tagSelectButton.layer.cornerRadius = 5;
        _tagSelectButton.layer.borderColor = tagColor.CGColor;
        _tagSelectButton.layer.borderWidth = 1;
        [_tagSelectButton addTarget:self action:@selector(tagSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tagView addSubview:_tagSelectButton];
        
        //"期"
        CGFloat qiW = 27;
        CGFloat btnW = (_tagView.width-qiW)/2;
        UILabel *qiLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnW, _tagSelectButton.bottom+5, qiW, 20)];
        qiLabel.text = @"期";
        qiLabel.font = SCFONT_SIZED(12);
        qiLabel.textAlignment = NSTextAlignmentCenter;
        [_tagView addSubview:qiLabel];
        
        //单子期数
        _realNumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, qiLabel.top, btnW, 20)];
        [_realNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _realNumButton.titleLabel.font = SCFONT_SIZED(12);
        [_realNumButton setTitle:@"0" forState:UIControlStateNormal];
        _realNumButton.layer.cornerRadius = 5;
        _realNumButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _realNumButton.layer.borderWidth = 1;
        [_realNumButton addTarget:self action:@selector(realNumClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tagView addSubview:_realNumButton];
        
        //增加期
        UIButton *numAddButton = [[UIButton alloc] initWithFrame:CGRectMake(btnW+qiW, _realNumButton.top, btnW, _realNumButton.height)];
        numAddButton.titleLabel.font = SCFONT_SIZED(15);
        [numAddButton setTitle:@"+" forState:UIControlStateNormal];
        [numAddButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        numAddButton.backgroundColor = HEX_RGB(@"#E5E5E9");
        numAddButton.layer.cornerRadius = 5;
        [numAddButton addTarget:self action:@selector(numAddClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tagView addSubview:numAddButton];
        
        //买法
        CGFloat y = numAddButton.bottom+5;
        CGFloat h = _tagView.height-y;
        _scoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, _tagView.width, h)];
        [_scoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scoreButton.titleLabel.font = SCFONT_SIZED(11);
        _scoreButton.layer.cornerRadius = 5;
        _scoreButton.layer.borderColor = [UIColor blackColor].CGColor;
        _scoreButton.layer.borderWidth = 1;
        [_scoreButton addTarget:self action:@selector(scoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tagView addSubview:_scoreButton];
        
    }
    return _tagView;
}

- (UIView *)recordView
{
    if (!_recordView) {
        CGFloat x = self.tagView.right + 20;
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(x, kMargin, SCREEN_WIDTH-x-kMargin, self.tagView.height)];
        [self.contentView addSubview:_recordView];
        
        //利润
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        _profitLabel.textAlignment = NSTextAlignmentLeft;
        [_recordView addSubview:_profitLabel];
        
        //止损线
        _breakLineButton = [[UIButton alloc] initWithFrame:CGRectMake(_profitLabel.right, 0, _recordView.width-_profitLabel.right, _profitLabel.height)];
        [_breakLineButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _breakLineButton.titleLabel.font = SCFONT_SIZED(13);
        _breakLineButton.layer.cornerRadius = 5;
        _breakLineButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _breakLineButton.layer.borderWidth = 1;
        [_breakLineButton addTarget:self action:@selector(breakLineClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_recordView addSubview:_breakLineButton];
        
        
        CGFloat labelH    = 20;
        UIFont *labelFont = SCFONT_SIZED(14);
        UIColor *labelColor = [UIColor grayColor];
        
        //已跟期数
        _buyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _profitLabel.bottom+6, 75, labelH)];
        _buyNumLabel.textAlignment = NSTextAlignmentLeft;
        _buyNumLabel.font = labelFont;
        _buyNumLabel.textColor = labelColor;
        [_recordView addSubview:_buyNumLabel];
        //
        //计划利润
        _planProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buyNumLabel.right, _buyNumLabel.top, 120, labelH)];
        _planProfitLabel.font = labelFont;
        _planProfitLabel.textColor = labelColor;
        [_recordView addSubview:_planProfitLabel];

        //每期利润
        UILabel *perProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _buyNumLabel.bottom+1, 100, labelH)];
        perProfitLabel.textAlignment = NSTextAlignmentLeft;
        perProfitLabel.text = @"其中：每期利润";
        perProfitLabel.font = labelFont;
        perProfitLabel.textColor = labelColor;
        [_recordView addSubview:perProfitLabel];
        
        _perProfitButton = [[UIButton alloc] initWithFrame:CGRectMake(perProfitLabel.right, perProfitLabel.top, 35, labelH)];
        [_perProfitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_perProfitButton setTitleColor:labelColor forState:UIControlStateNormal];
        _perProfitButton.titleLabel.font = labelFont;
        _perProfitButton.layer.cornerRadius = 5;
        _perProfitButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _perProfitButton.layer.borderWidth = 1;
        [_perProfitButton addTarget:self action:@selector(perProfitClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_recordView addSubview:_perProfitButton];
        //
        //固定利润
        UILabel *baseProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_perProfitButton.right+2, _perProfitButton.top, 58, labelH)];
        baseProfitLabel.text = @"固定利润";
        baseProfitLabel.font = labelFont;
        baseProfitLabel.textColor = labelColor;
        [_recordView addSubview:baseProfitLabel];
        //
        _baseProfitButton = [[UIButton alloc] initWithFrame:CGRectMake(baseProfitLabel.right, baseProfitLabel.top, 65, labelH)];
        [_baseProfitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_baseProfitButton setTitleColor:labelColor forState:UIControlStateNormal];
        _baseProfitButton.titleLabel.font = labelFont;
        _baseProfitButton.layer.cornerRadius = 5;
        _baseProfitButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _baseProfitButton.layer.borderWidth = 1;
        [_baseProfitButton addTarget:self action:@selector(baseProfitClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_recordView addSubview:_baseProfitButton];
        
        //计划获得
        _planGetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _baseProfitButton.bottom+6, _recordView.width, 20)];
        _planGetLabel.textAlignment = NSTextAlignmentLeft;
        [_recordView addSubview:_planGetLabel];
        
        
    }
    return _recordView;
}

- (UITextField *)noteField
{
    if (!_noteField) {
        _noteField = [[UITextField alloc] initWithFrame:CGRectMake(kMargin, self.recordView.bottom+kMargin, SCREEN_WIDTH-kMargin*2, 25)];
        _noteField.borderStyle = UITextBorderStyleLine;
        _noteField.font = SCFONT_SIZED(11);
        _noteField.placeholder = @"填写备注";
        _noteField.returnKeyType = UIReturnKeyDone;
        _noteField.delegate = self;
        [self.contentView addSubview:_noteField];
    }
    return _noteField;
}

- (UIView *)buyView
{
    if (!_buyView) {
        CGFloat y = self.noteField.bottom + kMargin;
        CGFloat h = self.line.top - y - kMargin;
        _buyView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, y, SCREEN_FIX(220), h)];
        _buyView.layer.cornerRadius = 8;
        _buyView.layer.borderWidth = 1;
        _buyView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.contentView addSubview:_buyView];
        
        //购买内容
        _boughtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _buyView.width, h/2)];
        _boughtLabel.textAlignment = NSTextAlignmentCenter;
        [_buyView addSubview:_boughtLabel];
        
        //未中按钮
        CGFloat btnW = (_buyView.width-kMargin*3)/2;
        CGFloat btnH = h/2-kMargin;
        
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMargin+(btnW+kMargin)*i, _boughtLabel.bottom, btnW, btnH)];
            btn.titleLabel.font = SCFONT_SIZED(15);
            btn.layer.cornerRadius = 5;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            [_buyView addSubview:btn];
            
            if (i==0) { //未中
                [btn setTitle:@"未    中" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(loseClicked:) forControlEvents:UIControlEventTouchUpInside];
                _loseButton = btn;
            }else{ //红单
                [btn setTitle:@"红    单" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(winClicked:) forControlEvents:UIControlEventTouchUpInside];
                _winButton = btn;
            }
        }
        
        //购买按钮
        _buyButton = [[UIButton alloc] initWithFrame:_buyView.bounds];
        [_buyButton setTitle:@"立 即 购 买" forState:UIControlStateNormal];
        _buyButton.titleLabel.font = SCFONT_BOLD_SIZED(20);
        _buyButton.backgroundColor = [UIColor whiteColor];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:_buyButton];
 
    }
    return _buyView;
}

- (UIButton *)linesButton
{
    if (!_linesButton) {
        CGFloat y = self.buyView.top;
        CGFloat h = (self.buyView.bottom - y - kMargin)/2;
        CGFloat x = self.buyView.right+kMargin;
        CGFloat w = SCREEN_WIDTH - x - kMargin;
        _linesButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _linesButton.layer.cornerRadius = 5;
        _linesButton.layer.borderWidth = 1;
        _linesButton.layer.borderColor = [UIColor blackColor].CGColor;
        [_linesButton setTitle:@"查看列表" forState:UIControlStateNormal];
        _linesButton.titleLabel.font = SCFONT_SIZED(15);
        [_linesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_linesButton addTarget:self action:@selector(linesClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_linesButton];
    }
    return _linesButton;
}

- (UIButton *)overButton
{
    if (!_overButton) {
        _overButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _overButton.frame = self.linesButton.frame;
        _overButton.top = self.linesButton.bottom + kMargin;
        [_overButton setTitle:@"结       束" forState:UIControlStateNormal];
        _overButton.layer.cornerRadius = self.linesButton.layer.cornerRadius;
        _overButton.layer.borderWidth = 1;
        _overButton.layer.borderColor = [UIColor blackColor].CGColor;
        _overButton.titleLabel.font = self.linesButton.titleLabel.font;
        [_overButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_overButton addTarget:self action:@selector(overClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_overButton];
    }
    return _overButton;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, kHomeCellH-1, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

NS_ASSUME_NONNULL_END
