//
//  StatsYearHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsYearHeaderView.h"

@interface StatsYearHeaderView ()
@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numsLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@end

@implementation StatsYearHeaderView

#pragma mark -data
- (void)setMonth:(MonthModel *)month
{
    _month = month;
    
    self.titleLabel.text  = [NSString stringWithFormat:@"%@ %@", (month.isOn ? @"▼" : @"▶︎"),month.title];
    
    self.numsLabel.text   = [NSString stringWithFormat:@"共%li单", month.records.count];
    
    self.profitLabel.text = [NSString stringWithFormat:@"%@", [SCUtilities removeFloatSuffix:month.allProfit]];
    
    self.profitLabel.textColor = [UIColor colorWithProfit:month.allProfit];
    
}

#pragma mark -action
- (void)clickAction
{
    _month.isOn ^= 1;
    if (self.clickBlock) {
        self.clickBlock();
    }
}


#pragma mark -ui
#define kMargin 15
- (UIControl *)bgView
{
    if (!_bgView) {
        CGFloat x = 15;
        CGFloat y = 5;
        _bgView = [[UIButton alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH-x*2, kSYHeaderH-y*2)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        [_bgView addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 100, self.bgView.height)];
        _titleLabel.font = SCFONT_SIZED(17);
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)numsLabel
{
    if (!_numsLabel) {
        _numsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, 0, 70, self.bgView.height)];
        _numsLabel.textColor = [UIColor grayColor];
        _numsLabel.font = SCFONT_SIZED(15);
        [self.bgView addSubview:_numsLabel];
    }
    return _numsLabel;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        CGFloat w = 190;
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.width-kMargin-w, 0, w, self.bgView.height)];
        _profitLabel.font = SCFONT_SIZED(22);
        _profitLabel.textColor = [UIColor grayColor];
        _profitLabel.textAlignment = NSTextAlignmentRight;
        _profitLabel.adjustsFontSizeToFitWidth = YES;
        [self.bgView addSubview:_profitLabel];
    }
    return _profitLabel;
}

@end
