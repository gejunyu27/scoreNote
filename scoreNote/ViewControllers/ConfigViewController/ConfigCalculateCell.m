//
//  ConfigCalculateCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import "ConfigCalculateCell.h"

@interface ConfigCalculateCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *inputButton;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *payLabel;
@end

@implementation ConfigCalculateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -data
- (void)setModel:(ConfigModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.inputButton setTitle:model.point forState:UIControlStateNormal];
    self.payLabel.text = model.pay;
    
    if (model.calculateType == ConfigCalculateTarget) {
        self.resultLabel.hidden = YES;
        self.payLabel.hidden    = YES;
    }else {
        self.resultLabel.hidden = NO;
        self.payLabel.hidden    = NO;
    }
}

#pragma mark -action
- (void)inputClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(calculateCellEditNumber:clickView:)]) {
        [self.delegate calculateCellEditNumber:_model clickView:sender];
    }
}


#pragma mark -UI

#define kMargin 15
#define kLabelFont SCFONT_SIZED(17)

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 80, kCCCellH)];
        _titleLabel.font = kLabelFont;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)inputButton
{
    if (!_inputButton) {
        CGFloat y = 5;
        _inputButton = [[UIButton alloc] initWithFrame:CGRectMake(self.titleLabel.right, y, 100, kCCCellH-y*2)];
        _inputButton.layer.cornerRadius = 4;
        _inputButton.layer.borderWidth = 1;
        _inputButton.titleLabel.font = kLabelFont;
        [_inputButton addTarget:self action:@selector(inputClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_inputButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_inputButton];
    }
    return _inputButton;
}

- (UILabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.inputButton.right+30, 0, 50, kCCCellH)];
        _resultLabel.font = kLabelFont;
        _resultLabel.text = @"结果：";
        [self.contentView addSubview:_resultLabel];
    }
    return _resultLabel;
}

- (UILabel *)payLabel
{
    if (!_payLabel) {
        CGFloat x = self.resultLabel.right + 10;
        CGFloat w = self.width-x-kMargin;
        _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, kCCCellH)];
        _payLabel.font = kLabelFont;
        [self.contentView addSubview:_payLabel];
    }
    return _payLabel;
}

@end

