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
    self.titleLabel.textColor = HEX_RGB(@"#797979");
    self.titleLabel.font = SCFONT_SIZED(14);
    self.contentLabel.font = SCFONT_BOLD_SIZED(19);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 15)];
        _titleLabel.textColor = HEX_RGB(@"#858585");
        _titleLabel.font = SCFONT_SIZED(13);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        CGFloat h = self.height - self.titleLabel.bottom;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-h, self.width, h)];
        _contentLabel.font = SCFONT_SIZED(14);
        _contentLabel.textColor = [UIColor blackColor];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
