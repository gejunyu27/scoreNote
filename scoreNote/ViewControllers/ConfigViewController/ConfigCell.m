//
//  ConfigCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/5.
//

#import "ConfigCell.h"

@interface ConfigCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIImageView *arrowIcon;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) ConfigModel *model;
@end

@implementation ConfigCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -data
- (void)update:(ConfigSectionModel *)sectionModel index:(NSInteger)index
{
    NSArray *models = sectionModel.models;
    if (index >= models.count) {
        return;
    }
    
    ConfigModel *model = models[index];
    self.model = model;
    
    self.sepLine.hidden = NO;
    if (index > 0 && index < models.count-1) { //中间的
        self.bgView.layer.cornerRadius = 0;
        self.bgView.layer.masksToBounds = NO;
        
    }else {
        self.bgView.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        self.bgView.layer.masksToBounds = YES;
        
        //特殊情况，总共只有一个元素
        if (models.count == 1) {
            self.bgView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner | kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
            self.sepLine.hidden = YES;
            
        }else if (index == 0) { //第一个
            // 只开启左上、右上圆角
            self.bgView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        }else if (index == models.count - 1) {
            //左下、右下角圆角
            self.bgView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
            self.sepLine.hidden = YES;
        }
        
    }

}


- (void)setModel:(ConfigModel *)model
{
    _model = model;
    
    //标题
    self.titleLabel.text = model.title;
    
    //内容/开关
    if (model.type == ConfigTypeIsSporttery) {
        self.contentLabel.hidden = YES;
        self.arrowIcon.hidden = YES;
        self.switchButton.hidden = NO;
        BOOL value = model.content.floatValue;
        [self.switchButton setImage:[UIImage imageNamed:(value?@"SwtichOn":@"SwtichOff")] forState:UIControlStateNormal];
        
    }else {
        self.contentLabel.hidden = NO;
        self.arrowIcon.hidden = NO;
        self.switchButton.hidden = YES;
        self.contentLabel.text = model.content?:@"";
    }
    
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
- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat x = kMargin;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH-x*2, kConfigCellH)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat x = kMargin;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 150, self.bgView.height)];
        _titleLabel.font = SCFONT_BOLD_SIZED(16);
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)arrowIcon
{
    if (!_arrowIcon) {
        CGFloat wh = 16;
        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.width-kMargin-wh, (self.bgView.height-wh)/2, wh, wh)];
        _arrowIcon.image = [UIImage imageNamed:@"RightArrow"];
        [self.bgView addSubview:_arrowIcon];
    }
    return _arrowIcon;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        CGFloat w = 100;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.arrowIcon.left-2-w, 0, w, self.bgView.height)];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = HEX_RGB(@"#9F9F9F");
        _contentLabel.font = SCFONT_BOLD_SIZED(15);
        [self.bgView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)switchButton
{
    if (!_switchButton) {
        CGFloat wh = 40;
        _switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.width-kMargin-wh, (self.bgView.height-wh)/2, wh, wh)];
        [_switchButton addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_switchButton];
    }
    return _switchButton;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        CGFloat h = 1;
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(kMargin, self.bgView.height-h, self.bgView.width-kMargin*2, h)];
        _sepLine.backgroundColor = HEX_RGB(@"#E6E6E6");
        [self.bgView addSubview:_sepLine];
    }
    return _sepLine;
}

@end
