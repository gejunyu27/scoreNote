//
//  ConfigHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/30.
//

#import "ConfigHeaderView.h"

@interface ConfigHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ConfigHeaderView

- (void)setTitle:(NSString *)title
{
    _title = title;

    self.titleLabel.text = title;
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, kConfigHeaderH-10)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = SCFONT_BOLD_SIZED(16);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
