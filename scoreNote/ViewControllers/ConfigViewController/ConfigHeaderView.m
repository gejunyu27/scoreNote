//
//  ConfigHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/27.
//

#import "ConfigHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ConfigHeaderView

- (void)setModel:(ConfigHeaderModel *)model
{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", (model.isOn ? @"▼" : @"▶︎"),model.name];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 140, kConfigHeaderH)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = SCFONT_BOLD_SIZED(16);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end

NS_ASSUME_NONNULL_END
