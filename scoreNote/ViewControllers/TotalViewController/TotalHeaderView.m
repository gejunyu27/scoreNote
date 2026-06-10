//
//  TotalHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/22.
//

#import "TotalHeaderView.h"

@interface TotalHeaderView ()
@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numsLabel;
@property (nonatomic, strong) UILabel *profitLabel;

@end

@implementation TotalHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -data
- (void)setModel:(TotalSectionModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", (model.isOn ? @"▼" : @"▶︎"),model.name];
    
    self.numsLabel.text = [NSString stringWithFormat:@"共%li单", model.recordList.count];
    
    self.profitLabel.text =[NSString stringWithFormat:@"%@", [SCUtilities removeFloatSuffix:model.allProfit]];
}

#pragma mark -ui
- (UIButton *)bgView
{
    if (!_bgView) {
        CGFloat x = 15;
        CGFloat y = 5;
        _bgView = [[UIButton alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH-x*2, kTotalHeaderH-y*2)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        [_bgView setCommonShadow];
        
        @weakify(self)
        [_bgView sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.clickBlock) {
                self.clickBlock();
            }
        }];
        
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 140, self.bgView.height)];
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)numsLabel
{
    if (!_numsLabel) {
        _numsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, 0, 80, self.bgView.height)];
        _numsLabel.textColor = [UIColor grayColor];
        _numsLabel.font = SCFONT_SIZED(13);
        [self.bgView addSubview:_numsLabel];
    }
    return _numsLabel;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        CGFloat w = 70;
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.width-w-15, 0, w, self.bgView.height)];
        _profitLabel.font = SCFONT_SIZED(13);
        _profitLabel.textColor = [UIColor grayColor];
        _profitLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:_profitLabel];
    }
    return _profitLabel;
}

@end


