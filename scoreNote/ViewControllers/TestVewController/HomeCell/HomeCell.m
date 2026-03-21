//
//  HomeCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import "HomeCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *bgView;          //背景框

@property (nonatomic, strong) UIButton *tagButton;     //标签
@property (nonatomic, strong) UILabel *profitLabel;    //利润
@property (nonatomic, strong) UIButton *realNumButton; //实际期数按钮
@property (nonatomic, strong) UIButton *scoreButton;   //买法
@property (nonatomic, strong) UILabel *tipsLabel;      //说明

@property (nonatomic, strong) UIButton *buyButton;      //购买按钮
@property (nonatomic, strong) UIButton *loseButton;     //未中
@property (nonatomic, strong) UIButton *winButton;      //红单
@property (nonatomic, strong) UIButton *detailButton;   //详情
@property (nonatomic, strong) UIButton *overButton;     //结束

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createButtons];
    }
    return self;
}

#pragma mark -data
- (void)setRecord:(RecordModel *)record
{
    _record = record;

    //标签
    [self.tagButton setTitle:(_record.tagModel ? _record.tagModel.name : @"无跟单") forState:UIControlStateNormal];
    
    //利润
    CGFloat allProfit = record.allProfit;
    self.profitLabel.text = [NSString stringWithFormat:@"¥%@", [SCUtilities removeFloatSuffix:allProfit]];
//
    //实际期数
    [self.realNumButton setTitle:[NSString stringWithFormat:@"第%li期", _record.realNum] forState:UIControlStateNormal];
//
    //本期买法
    [self.scoreButton setTitle:(record.currentScore.length == 0 ? @"编辑本期买法" : record.currentScore) forState:UIControlStateNormal];

    //备注
    NSInteger num = record.lineList.count+1; //下一期期数
    CGFloat planProfit = num*record.profitPerLine+record.baseProfit;
    self.tipsLabel.text = [NSString stringWithFormat:@"%lix%@+%@=%@", num,[SCUtilities removeFloatSuffix:record.profitPerLine],[SCUtilities removeFloatSuffix:record.baseProfit],[SCUtilities removeFloatSuffix:planProfit]];
    
    //购买
    BOOL isBought = record.lineList.count > 0 && !record.lineList.lastObject.isOver;  //购买过
    self.buyButton.hidden = isBought;

    //止损线
    if (record.isBreaking) {
        self.profitLabel.textColor = [UIColor redColor];
        [self.buyButton setTitle:@"保本或止损" forState:UIControlStateNormal];
        
    }else {
        self.profitLabel.textColor = HEX_RGB(@"#6271DD");
        if (!isBought) {
            CGFloat planGet = MAX(planProfit - allProfit, 0);
            [self.buyButton setTitle:[NSString stringWithFormat:@"立即购买（+%@）",[SCUtilities removeFloatSuffix:planGet]] forState:UIControlStateNormal];
        }

        
    }

//    //买过的单子 标绿提醒 到第二天6点前消失
//    BOOL isBuyToday = NO;
//    if (record.lineList.count > 0) {
//        LineModel *lastModel = record.lineList.lastObject;
//        if (!lastModel.isOver) { //最后一个没结束
//            NSDate *buyDate = lastModel.beginTime;
//            NSDate *today   = [NSDate date];
//
//            NSInteger days = [today daysBetweenDate:buyDate];
//
//            if (days == 0) {
//                isBuyToday = YES;
//
//            }else if (days == 1) { //已经不是同一天，查看是不是第二天早上6点前
//                NSInteger hour = [today getStringWithDateFormat:@"HH"].integerValue;
//                if (hour < 6) {
//                    isBuyToday = YES;
//                }
//            }
//        }
//    }
//    _buyView.layer.borderColor = isBuyToday ? HEX_RGB(@"#49AB58").CGColor : [UIColor blackColor].CGColor;
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

- (void)scoreClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellEditScore:clickView:)]) {
        [self.delegate homeCellEditScore:_record clickView:sender];
    }
}

- (void)buyClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellBuy:clickView:)]) {
        [self.delegate homeCellBuy:_record clickView:sender];
    }
}

- (void)detailClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeCellShowDetails:)]) {
        [self.delegate homeCellShowDetails:_record];
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

#pragma mark -ui
- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat horEdge = 25;
        CGFloat verEdge = 10;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(horEdge, verEdge, SCREEN_WIDTH-horEdge*2, kHomeCellH-verEdge*2)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.shadowOpacity = 0.2;
        _bgView.layer.shadowOffset = CGSizeMake(2, 2);
        _bgView.layer.shadowRadius = 4;

        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIButton *)tagButton
{
    if (!_tagButton) {
        CGFloat w = 120;
        _tagButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, w, w*0.8)];
        [_tagButton setBackgroundImage:[UIImage imageNamed:@"TagIcon"] forState:UIControlStateNormal];
        _tagButton.titleLabel.font = SCFONT_BOLD_SIZED(16);
        [_tagButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 4)];
        [_tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_tagButton addTarget:self action:@selector(tagSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_tagButton];
    }
    return _tagButton;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tagButton.right+10, 15, 90, 30)];
        _profitLabel.font = SCFONT_SIZED(23);
        [self.bgView addSubview:_profitLabel];
    }
    return _profitLabel;
}

- (UIButton *)realNumButton
{
    if (!_realNumButton) {
        _realNumButton = [[UIButton alloc] initWithFrame:CGRectMake(self.profitLabel.left, self.profitLabel.bottom+15, 70, 25)];
        _realNumButton.titleLabel.font = SCFONT_SIZED(15);
        _realNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_realNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_realNumButton addTarget:self action:@selector(realNumClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_realNumButton];
    }
    return _realNumButton;
}

- (UIButton *)scoreButton
{
    if (!_scoreButton) {
        CGFloat x = self.realNumButton.right;
        CGFloat w = self.bgView.width-x-10;
        _scoreButton = [[UIButton alloc] initWithFrame:CGRectMake(x, self.realNumButton.top, w, self.realNumButton.height)];
        [_scoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scoreButton.titleLabel.font = self.realNumButton.titleLabel.font;
        _scoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_scoreButton addTarget:self action:@selector(scoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_scoreButton];
    }
    return _scoreButton;
}


- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        CGFloat w = 110;
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.width-10-w, 15, w, 30)];
        _tipsLabel.textColor = [UIColor grayColor];
        _tipsLabel.textAlignment = NSTextAlignmentRight;
        _tipsLabel.font = SCFONT_SIZED(11);
        [self.bgView addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

- (void)createButtons
{
    CGFloat horEdge = 15;
    CGFloat verEdge = 15;
    CGFloat y       = self.tagButton.bottom+10;
    CGFloat w       = (self.bgView.width-horEdge*5)/4;
    CGFloat h       = self.bgView.height - verEdge - y;
    
    CGFloat cornerRadius = 5;
    UIColor *bgColor     = HEX_RGB(@"#1C2A4B");
    UIFont *font         = SCFONT_SIZED(15);
    UIColor *textColor   = [UIColor whiteColor];
    
    for (int i=0; i<4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(horEdge+(horEdge+w)*i, y, w, h)];
        btn.backgroundColor = bgColor;
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        btn.layer.cornerRadius = cornerRadius;
        [self.bgView addSubview:btn];
        
        if (i == 0) {
            _loseButton = btn;
            [_loseButton setTitle:@"未 中" forState:UIControlStateNormal];
            [_loseButton addTarget:self action:@selector(loseClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 1) {
            _winButton = btn;
            [_winButton setTitle:@"红 单" forState:UIControlStateNormal];
            [_winButton addTarget:self action:@selector(winClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 2) {
            _detailButton = btn;
            [_detailButton setTitle:@"详 情" forState:UIControlStateNormal];
            [_detailButton addTarget:self action:@selector(detailClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 3) {
            _overButton = btn;
            [_overButton setTitle:@"结 束" forState:UIControlStateNormal];
            [_overButton addTarget:self action:@selector(overClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(horEdge, y, w*2+horEdge, h)];
    _buyButton.backgroundColor = bgColor;
    [_buyButton setTitleColor:textColor forState:UIControlStateNormal];
    _buyButton.titleLabel.font = font;
    _buyButton.layer.cornerRadius = cornerRadius;
    [_buyButton addTarget:self action:@selector(buyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_buyButton];
    
}



//
//#pragma mark -UITextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([self.delegate respondsToSelector:@selector(homeCellEditNote:record:)]) {
//        [self.delegate homeCellEditNote:textField.text record:_record];
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//

@end

NS_ASSUME_NONNULL_END
