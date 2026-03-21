//
//  RecordDetailCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/21.
//

#import "RecordDetailCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordDetailCell ()
@property (nonatomic, strong) LineModel *line;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *rowLabel;
@property (nonatomic, strong) UIButton *outButton;
@property (nonatomic, strong) UIButton *getButton;
@property (nonatomic, strong) UILabel *tipsLabel;
//@property (nonatomic, strong) UILabel *scoreLabel;
//@property (nonatomic, strong) UILabel *beginTimeLabel;

@end

@implementation RecordDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setLine:(LineModel *)line row:(NSInteger)row canEdit:(BOOL)canEdit
{
    _line = line;
    self.userInteractionEnabled = canEdit;
    
    self.rowLabel.text = [NSString stringWithFormat:@"%li", row+1];
    
    [self.outButton setTitle:[SCUtilities removeFloatSuffix:line.outMoney] forState:UIControlStateNormal];
    
    NSString *getStr = line.isOver ? [SCUtilities removeFloatSuffix:line.getMoney] : @"";
    [self.getButton setTitle:getStr forState:UIControlStateNormal];
    
    NSString *score;
    if (line.isOver) {
        score = line.overScore?:@"";
        
    }else {
        score = line.record.currentScore?:@"";
    }
    
    NSString *beginTime  = [line.beginTime getStringWithDateFormat:@"yyyy-MM-dd"];
    self.tipsLabel.text  = [NSString stringWithFormat:@"%@   %@", score, beginTime];

}

#pragma mark -action
- (void)outClicked:(UIButton *)sender
{
    if (!_line.isOver) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(recordDetailCellEditOutMoney:clickView:)]) {
        [self.delegate recordDetailCellEditOutMoney:_line clickView:sender];
    }
}

- (void)getClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(recordDetailCellEditGetMoney:clickView:)]) {
        [self.delegate recordDetailCellEditGetMoney:_line clickView:sender];
    }
}

#pragma mark -ui
- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat x = 15;
        CGFloat y = 5;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH-x*2, kRDCellH-y*2)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        [_bgView setCommonShadow];
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)rowLabel
{
    if (!_rowLabel) {
        _rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, self.bgView.height)];
        _rowLabel.textAlignment = NSTextAlignmentLeft;
        _rowLabel.font = SCFONT_SIZED(12);
        [self.bgView addSubview:_rowLabel];
    }
    return _rowLabel;
}

- (UIButton *)outButton
{
    if (!_outButton) {
        CGFloat y = 12;
        _outButton = [[UIButton alloc] initWithFrame:CGRectMake(self.rowLabel.right, y, 70, self.bgView.height-y*2)];
        [_outButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _outButton.layer.cornerRadius = 5;
        _outButton.layer.borderWidth = 0.5;
        _outButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _outButton.titleLabel.font = SCFONT_SIZED(14);
        [_outButton addTarget:self action:@selector(outClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_outButton];
    }
    return _outButton;
}

- (UIButton *)getButton
{
    if (!_getButton) {
        _getButton = [[UIButton alloc] initWithFrame:self.outButton.frame];
        _getButton.left = _outButton.right + 10;
        [_getButton setTitleColor:_outButton.currentTitleColor forState:UIControlStateNormal];
        _getButton.titleLabel.font = _outButton.titleLabel.font;
        _getButton.layer.cornerRadius = _outButton.layer.cornerRadius;
        _getButton.layer.borderWidth = _outButton.layer.borderWidth;
        _getButton.layer.borderColor = _outButton.layer.borderColor;
        [_getButton addTarget:self action:@selector(getClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_getButton];
    }
    return _getButton;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        CGFloat edge = 10;
        CGFloat x = self.getButton.right + 10;
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,0, self.bgView.width-edge-x, self.bgView.height)];
        _tipsLabel.textColor = [UIColor grayColor];
        _tipsLabel.textAlignment = NSTextAlignmentRight;
        _tipsLabel.font = SCFONT_SIZED(12);
        [self.bgView addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

@end

NS_ASSUME_NONNULL_END
