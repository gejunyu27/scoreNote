//
//  HomeCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import "HomeCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell ()
@property (nonatomic, strong) UIView *tagView;               //标签区
@property (nonatomic, strong) UIButton *tagNameButton;       //标签名
@property (nonatomic, strong) UIButton *tagNumButton;        //标签期数
@property (nonatomic, strong) UIButton *scoreButton;         //买法按钮

@property (nonatomic, strong) UIView *recordView;            //记录区
@property (nonatomic, strong) UILabel *profitLabel;          //利润
@property (nonatomic, strong) UIButton *breakButton;         //止损
@property (nonatomic, strong) UILabel *buyNumLabel;          //已跟期数
@property (nonatomic, strong) UIButton *perProfitButton;     //每期利润
@property (nonatomic, strong) UIButton *baseProfitButton;    //固定利润
@property (nonatomic, strong) UILabel *planProfitLabel;      //总计利润
@property (nonatomic, strong) UILabel *planGetLabel;         //预期获得


@property (nonatomic, strong) UIView *line;              //分割线

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark -ui
- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self recordView];
    [self line];
}

#define kMargin 10

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, SCREEN_WIDTH/4, 95)];
        [self.contentView addSubview:_tagView];
        
        //单子
        _tagNameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _tagView.width, 25)];
        [_tagNameButton setTitle:@"无跟单" forState:UIControlStateNormal];
        [_tagNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tagNameButton.titleLabel.font = SCFONT_SIZED(12);
        _tagNameButton.layer.cornerRadius = 5;
        _tagNameButton.layer.borderColor = [UIColor blackColor].CGColor;
        _tagNameButton.layer.borderWidth = 1;
        [_tagView addSubview:_tagNameButton];
        
        //"期"
        CGFloat qiW = 27;
        CGFloat btnW = (_tagView.width-qiW)/2;
        UILabel *qiLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnW, _tagNameButton.bottom+5, qiW, 20)];
        qiLabel.text = @"期";
        qiLabel.font = SCFONT_SIZED(12);
        qiLabel.textAlignment = NSTextAlignmentCenter;
        [_tagView addSubview:qiLabel];
        
        //单子期数
        _tagNumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, qiLabel.top, btnW, 20)];
        [_tagNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tagNumButton.titleLabel.font = SCFONT_SIZED(12);
        [_tagNumButton setTitle:@"111" forState:UIControlStateNormal];
        _tagNumButton.layer.cornerRadius = 5;
        _tagNumButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _tagNumButton.layer.borderWidth = 1;
        [_tagView addSubview:_tagNumButton];
        
        //增加期
        UIButton *numAddButton = [[UIButton alloc] initWithFrame:CGRectMake(btnW+qiW, _tagNumButton.top, btnW, _tagNumButton.height)];
        numAddButton.titleLabel.font = SCFONT_SIZED(15);
        [numAddButton setTitle:@"+" forState:UIControlStateNormal];
        [numAddButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        numAddButton.backgroundColor = HEX_RGB(@"#E5E5E9");
        numAddButton.layer.cornerRadius = 5;
        [_tagView addSubview:numAddButton];
        
        //买法
        CGFloat y = numAddButton.bottom+5;
        CGFloat h = _tagView.height-y;
        _scoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, _tagView.width, h)];
        [_scoreButton setTitle:@"添加本期买法" forState:UIControlStateNormal];
        [_scoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scoreButton.titleLabel.font = SCFONT_SIZED(11);
        _scoreButton.layer.cornerRadius = 5;
        _scoreButton.layer.borderColor = [UIColor blackColor].CGColor;
        _scoreButton.layer.borderWidth = 1;
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
        _profitLabel.text = @"当前利润：-5839";
        [_recordView addSubview:_profitLabel];
        //
        _breakButton = [[UIButton alloc] initWithFrame:CGRectMake(_profitLabel.right, 0, _recordView.width-_profitLabel.right, _profitLabel.height)];
        [_breakButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_breakButton setTitle:@"止损线5000" forState:UIControlStateNormal];
        _breakButton.titleLabel.font = SCFONT_SIZED(13);
        _breakButton.layer.cornerRadius = 5;
        _breakButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _breakButton.layer.borderWidth = 1;
        [_recordView addSubview:_breakButton];
        
        
        CGFloat labelH    = 20;
        UIFont *labelFont = SCFONT_SIZED(14);
        UIColor *labelColor = [UIColor grayColor];
        
        //已跟期数
        _buyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _profitLabel.bottom+6, 75, labelH)];
        _buyNumLabel.textAlignment = NSTextAlignmentLeft;
        _buyNumLabel.font = labelFont;
        _buyNumLabel.text = @"已跟78期";
        _buyNumLabel.textColor = labelColor;
        [_recordView addSubview:_buyNumLabel];
        //
        //计划利润
        _planProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buyNumLabel.right, _buyNumLabel.top, 120, labelH)];
        _planProfitLabel.text = @"计划利润:7802";
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
        [_perProfitButton setTitle:@"50" forState:UIControlStateNormal];
        [_perProfitButton setTitleColor:labelColor forState:UIControlStateNormal];
        _perProfitButton.titleLabel.font = labelFont;
        _perProfitButton.layer.cornerRadius = 5;
        _perProfitButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _perProfitButton.layer.borderWidth = 1;
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
        [_baseProfitButton setTitle:@"5000" forState:UIControlStateNormal];
        [_baseProfitButton setTitleColor:labelColor forState:UIControlStateNormal];
        _baseProfitButton.titleLabel.font = labelFont;
        _baseProfitButton.layer.cornerRadius = 5;
        _baseProfitButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _baseProfitButton.layer.borderWidth = 1;
        [_recordView addSubview:_baseProfitButton];
        
        //计划获得
        _planGetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _baseProfitButton.bottom+6, _recordView.width, 20)];
        _planGetLabel.textAlignment = NSTextAlignmentLeft;
        _planGetLabel.text = @"本次投注所需利润：10283";
        [_recordView addSubview:_planGetLabel];
        
        
    }
    return _recordView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, kHomeCellH-0.5, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

NS_ASSUME_NONNULL_END
