//
//  StatisticsRecordHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import "StatisticsRecordHeaderView.h"

@interface StatisticsRecordHeaderView ()
@property (nonatomic, strong) UIControl *clickView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numsLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UIView *sepLine;

@end

@implementation StatisticsRecordHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self clickView];
        [self sepLine];
    }
    return self;
}

#pragma mark -data
- (void)setMonth:(MonthModel *)month
{
    _month = month;
    
    self.titleLabel.text  = [NSString stringWithFormat:@"%@ %@", (month.isOn ? @"▼" : @"▶︎"),month.title];
    
    self.numsLabel.text   = [NSString stringWithFormat:@"共%li单", month.records.count];
    
    self.profitLabel.text = [NSString stringWithFormat:@"%@", [SCUtilities removeFloatSuffix:month.allProfit]];
    self.profitLabel.textColor = month.allProfit>=0 ? COLOR_WIN_NUM : COLOR_LOSE_NUM;
    
}

#pragma makr -action
- (void)clickAction
{
    _month.isOn ^= 1;
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark -ui
#define kEdge 20
- (UIControl *)clickView
{
    if (!_clickView) {
    
        _clickView = [[UIButton alloc] initWithFrame:CGRectMake(kEdge, 0, SCREEN_WIDTH-kEdge*2, kSRHeaderH)];
        [_clickView addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_clickView];
    }
    return _clickView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, 100, kSRHeaderH)];
        _titleLabel.font = SCFONT_SIZED(17);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)numsLabel
{
    if (!_numsLabel) {
        _numsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, 0, 70, kSRHeaderH)];
        _numsLabel.textColor = [UIColor grayColor];
        _numsLabel.font = SCFONT_SIZED(15);
        [self.contentView addSubview:_numsLabel];
    }
    return _numsLabel;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        CGFloat w = 70;
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kEdge-w-15, 0, w, kSRHeaderH)];
        _profitLabel.font = SCFONT_SIZED(15);
        _profitLabel.textColor = [UIColor grayColor];
        _profitLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_profitLabel];
    }
    return _profitLabel;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        CGFloat h = 1;
        CGFloat x = kEdge+5;
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(x, kSRHeaderH-h, SCREEN_WIDTH-x*2, h)];
        _sepLine.backgroundColor = HEX_RGB(@"#EEEEEE");
        [self.contentView addSubview:_sepLine];
    }
    return _sepLine;
}

@end
