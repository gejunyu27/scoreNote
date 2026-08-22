//
//  ConfigCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/5.
//

#import "ConfigCell.h"

@interface ConfigCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIImageView *arrowIcon;
@property (nonatomic, strong) ConfigModel *model;
@end

@implementation ConfigCell
#pragma mark -data
- (void)update:(ConfigSectionModel *)sectionModel index:(NSInteger)index
{
    NSArray *models = sectionModel.models;
    if (index < 0 || index >= models.count) {
        return;
    }
    
    _model = models[index];
    
    
    //标题
    self.titleLabel.text = _model.title;
    
    //内容/开关
    if (_model.type == ConfigTypeIsSporttery) {
        self.contentLabel.hidden = YES;
        self.arrowIcon.hidden = YES;
        self.switchButton.hidden = NO;
        BOOL value = _model.content.floatValue;
        [self.switchButton setImage:[UIImage imageNamed:(value?@"SwtichOn":@"SwtichOff")] forState:UIControlStateNormal];
        
    }else {
        self.contentLabel.hidden = NO;
        self.arrowIcon.hidden = NO;
        self.switchButton.hidden = YES;
        self.contentLabel.text = _model.content?:@"";
    }
    
    //UI
    [self updateCornerWithIndex:index dataCount:models.count];
    

}


#pragma mark -action
- (void)switchClicked
{
    if ([self.delegate respondsToSelector:@selector(configCellSwitchClicked:)]) {
        [self.delegate configCellSwitchClicked:self.model];
    }
}

#pragma mark -ui
#define kMargin 15
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat x = kMargin;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 150, kConfigCellH)];
        _titleLabel.font = SCFONT_BOLD_SIZED(16);
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)arrowIcon
{
    if (!_arrowIcon) {
        CGFloat wh = 16;
        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-self.edge*2-kMargin-wh, (kConfigCellH-wh)/2, wh, wh)];
        _arrowIcon.image = [UIImage imageNamed:@"RightArrow"];
        [self.contentView addSubview:_arrowIcon];
    }
    return _arrowIcon;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        CGFloat w = 100;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.arrowIcon.left-2-w, 0, w, kConfigCellH)];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = HEX_RGB(@"#9F9F9F");
        _contentLabel.font = SCFONT_BOLD_SIZED(15);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)switchButton
{
    if (!_switchButton) {
        CGFloat wh = 40;
        _switchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (kConfigCellH-wh)/2, wh, wh)];
        _switchButton.right = self.arrowIcon.right;
        [_switchButton addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_switchButton];
    }
    return _switchButton;
}

@end
