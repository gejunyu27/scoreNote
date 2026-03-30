//
//  ConfigCommonCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import "ConfigCommonCell.h"

@interface ConfigCommonCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *inputButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *casinoButton;
@end

@implementation ConfigCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self resetButton];
    }
    return self;
}

#pragma mark -data
- (void)setModel:(ConfigModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    
    if (model.configType == ConfigTypeIsCasino) {
        self.inputButton.hidden = YES;
        self.resetButton.hidden = YES;
        self.casinoButton.hidden = NO;
        
        [self.casinoButton setImage:(model.value?[UIImage imageNamed:@"SwtichOn"]:[UIImage imageNamed:@"SwtichOff"]) forState:UIControlStateNormal];
        
    }else {
        self.inputButton.hidden = NO;
        self.resetButton.hidden = NO;
        self.casinoButton.hidden = YES;
        
        [self.inputButton setTitle:[SCUtilities removeFloatSuffix:model.value] forState:UIControlStateNormal];
    }
    
}

#pragma mark -action
- (void)inputClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(commonCellEditValue:clickView:)]) {
        [self.delegate commonCellEditValue:_model clickView:sender];
    }
}

- (void)resetClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(commonCellReset:)]) {
        [self.delegate commonCellReset:_model];
    }
}

- (void)switchClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(commonCellSwitchChanged:)]) {
        [self.delegate commonCellSwitchChanged:_model];
    }
}

#pragma mark -ui
#define kLabelFont SCFONT_SIZED(17)

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, kConfigCellH)];
        _titleLabel.font = kLabelFont;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)resetButton
{
    if (!_resetButton) {
        CGFloat wh = 25;
        _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50-wh, (kConfigCellH-wh)/2, wh, wh)];
        [_resetButton setImage:[UIImage imageNamed:@"Reset"] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_resetButton];
    }
    return _resetButton;
}

- (UIButton *)inputButton
{
    if (!_inputButton) {
        CGFloat y = 15;
        CGFloat x = self.titleLabel.right+10;
        _inputButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, self.resetButton.left-x-25, kConfigCellH-y*2)];
        _inputButton.layer.cornerRadius = 4;
        _inputButton.layer.borderWidth = 1;
        _inputButton.titleLabel.font = kLabelFont;
        [_inputButton addTarget:self action:@selector(inputClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_inputButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_inputButton];
    }
    return _inputButton;
}

- (UIButton *)casinoButton
{
    if (!_casinoButton) {
        CGFloat wh = 55;
        _casinoButton = [[UIButton alloc] initWithFrame:CGRectMake(self.resetButton.right-wh, (kConfigCellH-wh)/2, wh, wh)];
        [_casinoButton addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_casinoButton];
    }
    return _casinoButton;
}

@end

