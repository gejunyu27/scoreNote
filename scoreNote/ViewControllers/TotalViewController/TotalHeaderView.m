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
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation TotalHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        @weakify(self)
//        [self.control sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
//            @strongify(self)
//            if (self.clickBlock) {
//                self.clickBlock();
//            }
//        }];
    }
    return self;
}

#pragma mark -data
- (void)setModel:(TotalSectionModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@    共%li单", (model.isOn ? @"▼" : @"▶︎"),model.name, model.recordList.count]; ;

    self.tipsLabel.text =[NSString stringWithFormat:@"总计：%@", [SCUtilities removeFloatSuffix:model.allProfit]];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, self.bgView.height)];
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        CGFloat w = 105;
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.width-w-15, 0, w, self.bgView.height)];
        _tipsLabel.font = SCFONT_SIZED(12);
        _tipsLabel.textColor = [UIColor grayColor];
        _tipsLabel.textAlignment = NSTextAlignmentRight;
        
        [self.bgView addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

@end


