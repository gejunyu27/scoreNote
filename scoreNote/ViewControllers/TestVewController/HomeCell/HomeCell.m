//
//  HomeCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import "HomeCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell ()
@property (nonatomic, strong) UIView *tagView;           //标签区
@property (nonatomic, strong) UIButton *tagNameButton;   //标签名
@property (nonatomic, strong) UIButton *tagNumButton;    //标签期数
@property (nonatomic, strong) UIButton *scoreButton;     //买法按钮

@property (nonatomic, strong) UIView *recordView;        //记录区



@property (nonatomic, strong) UIView *line;              //分割线

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark -ui
- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self tagView];
    [self recordView];
    [self line];
}

#define kMargin 10

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, SCREEN_WIDTH/4, 100)];
        [self.contentView addSubview:_tagView];
        
        _tagNameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _tagView.width, 30)];
        [_tagNameButton setTitle:@"无跟单" forState:UIControlStateNormal];
        [_tagNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tagNameButton.titleLabel.font = SCFONT_SIZED(13);
        _tagNameButton.layer.cornerRadius = 5;
        _tagNameButton.layer.borderColor = [UIColor blackColor].CGColor;
        _tagNameButton.layer.borderWidth = 1;
        [_tagView addSubview:_tagNameButton];
        
        CGFloat qiW = 30;
        CGFloat btnW = (_tagView.width-qiW)/2;
        UILabel *qiLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnW, _tagNameButton.bottom+5, qiW, 20)];
        qiLabel.text = @"期";
        qiLabel.font = SCFONT_SIZED(12);
        qiLabel.textAlignment = NSTextAlignmentCenter;
        [_tagView addSubview:qiLabel];
        
        _tagNumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, qiLabel.top, btnW, 20)];
        [_tagNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tagNumButton.titleLabel.font = SCFONT_SIZED(12);
        _tagNumButton.layer.cornerRadius = 5;
        _tagNumButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        _tagNumButton.layer.borderWidth = 1;
        [_tagView addSubview:_tagNumButton];
        
        UIButton *numAddButton = [[UIButton alloc] initWithFrame:CGRectMake(btnW+qiW, _tagNumButton.top, btnW, _tagNumButton.height)];
        numAddButton.titleLabel.font = SCFONT_SIZED(15);
        [numAddButton setTitle:@"+" forState:UIControlStateNormal];
        [numAddButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        numAddButton.backgroundColor = HEX_RGB(@"#E5E5E9");
        numAddButton.layer.cornerRadius = 5;
        [_tagView addSubview:numAddButton];
        
        CGFloat y = numAddButton.bottom+5;
        CGFloat h = _tagView.height-y;
        _scoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, _tagView.width, h)];
        [_scoreButton setTitle:@"添加本期买法" forState:UIControlStateNormal];
        [_scoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scoreButton.titleLabel.font = SCFONT_SIZED(12);
        _scoreButton.layer.cornerRadius = 5;
        _scoreButton.layer.borderColor = [UIColor blackColor].CGColor;
        _scoreButton.layer.borderWidth = 1;
        [_tagView addSubview:_scoreButton];
    
    }
    return _tagView;
}

- (UIView *)recordView
{
    if (!_recordView) {
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, kHomeCellH/2)];
        [self.contentView addSubview:_recordView];
    }
    return _recordView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, kHomeCellH-0.5, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

NS_ASSUME_NONNULL_END
