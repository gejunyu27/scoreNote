//
//  FinanceButton.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import "FinanceButton.h"

@interface FinanceButton ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation FinanceButton

- (void)largerSize
{
//    self.titleLabel.textColor = HEX_RGB(@"#797979");
    self.titleLabel.font = SCFONT_SIZED(13);
    self.contentLabel.font = SCFONT_BOLD_SIZED(28);
}

- (void)setModel:(FinanceModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    if (model.changeColor) {
        CGFloat num = model.content.floatValue;
        self.contentLabel.textColor = [UIColor colorWithProfit:num];
        
    }else {
        self.contentLabel.textColor = [UIColor blackColor];
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _titleLabel.textColor = HEX_RGB(@"#9F9F9F");
        _titleLabel.font = SCFONT_SIZED(12);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        CGFloat h = self.height - self.titleLabel.bottom;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-h, self.width, h)];
        _contentLabel.font = SCFONT_SIZED(16);
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
