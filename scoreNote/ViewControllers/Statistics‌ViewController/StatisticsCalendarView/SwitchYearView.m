//
//  SwitchYearView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/17.
//

#import "SwitchYearView.h"

@interface SwitchYearView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) NSMutableArray <NSString *> *yearTitles;

@end

@implementation SwitchYearView



#pragma mark -data
- (void)refresh:(NSArray<YearModel *> *)yearModels
{
    [self.yearTitles removeAllObjects];
    
    if (yearModels.count > 0) {
        for (YearModel *year in yearModels) {
            [self.yearTitles addObject:year.title];
        }
        
        [self updateUI];
    }
}

#pragma mark -public
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSInteger validIndex = MAX(MIN(_yearTitles.count-1, selectedIndex), 0) ;
    
    if (_selectedIndex == validIndex) {
        return;
    }

    _selectedIndex = validIndex;
    
    [self updateUI];
}

- (void)updateUI
{
    if (_selectedIndex >= _yearTitles.count) {
        return;
    }
    
    NSString *title = _yearTitles[_selectedIndex];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    BOOL leftCanClick = YES;
    BOOL rightCanClick = YES;
    if (_selectedIndex == 0) {
        leftCanClick = NO;
    }
    //不能用else if 有可能只有1个，两边都不能点
    if (_selectedIndex == _yearTitles.count - 1) {
        rightCanClick = NO;
    }
    
    [self setSender:self.leftButton canClick:leftCanClick];
    [self setSender:self.rightButton canClick:rightCanClick];
}

- (void)setSender:(UIButton *)sender canClick:(BOOL)canClick
{
    [sender setTitleColor:(canClick ? [UIColor blackColor] : HEX_RGB(@"#A5A5A5")) forState:UIControlStateNormal];
    sender.userInteractionEnabled = canClick;
}

#pragma mark -action
- (void)btnClicked:(UIButton *)sender
{
    sender == self.leftButton ? self.selectedIndex-- : self.selectedIndex++;
    
    if ([self.delegate respondsToSelector:@selector(switchYearViewSelected:)]) {
        [self.delegate switchYearViewSelected:_selectedIndex];
    }
}

#pragma mark -ui
- (UIButton *)leftButton
{
    if (!_leftButton) {
        CGFloat wh = self.height;
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
        [_leftButton setTitle:@"◀" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = SCFONT_SIZED(12);
        [_leftButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];

    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        CGFloat wh = self.height;
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-wh, 0, wh, wh)];
        [_rightButton setTitle:@"▶" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = self.leftButton.titleLabel.font;
        [_rightButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        CGFloat margin = 10;
        CGFloat x = self.leftButton.right + margin;
        _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, self.rightButton.left-margin-x, self.height)];
        _titleButton.titleLabel.font = SCFONT_SIZED(14);
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_titleButton];
    }
    return _titleButton;
}

- (NSMutableArray<NSString *> *)yearTitles
{
    if (!_yearTitles) {
        _yearTitles = [NSMutableArray array];
    }
    return _yearTitles;
}

@end
