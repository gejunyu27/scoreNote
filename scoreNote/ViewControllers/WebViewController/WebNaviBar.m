//
//  WebNaviBar.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/3.
//

#import "WebNaviBar.h"

@interface WebNaviBar ()
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnList;
@end

@implementation WebNaviBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark -set&get
- (void)createButtonsWithTitleList:(NSArray <NSString *> *)titleList selectedColor:(UIColor *)selectedColor font:(nullable UIFont *)font
{
    [self removeOldBtns];
    
    NSInteger count = titleList.count;
    
    CGFloat w = self.width/count;
    
    self.selectedLine.width = w;
    self.selectedLine.backgroundColor = selectedColor?:[UIColor redColor];
    
    for (int i=0; i<count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w*i, self.topLine.bottom, w, self.selectedLine.top - self.topLine.bottom)];
        [btn setTitleColor:HEX_RGB(@"#6E6E6E") forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedLine.backgroundColor forState:UIControlStateSelected];
        btn.titleLabel.font = font?:SCFONT_SIZED(18);
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = titleList[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.btnList addObject:btn];
        
        if (i==0) {
            btn.selected = YES;
        }
    }
}

- (void)createButtonsWithTitleList:(NSArray <NSString *> *)titleList selectedColor:(UIColor *)selectedColor
{
    [self createButtonsWithTitleList:titleList selectedColor:selectedColor font:nil];
}

//移除旧按钮
- (void)removeOldBtns
{
    for (UIButton *btn in self.btnList) {
        [btn removeFromSuperview];
    }
    
    [self.btnList removeAllObjects];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex || selectedIndex >= _btnList.count || selectedIndex < 0) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    if ([self.delegate respondsToSelector:@selector(webNaviBarSelectIndex:)]) {
        [self.delegate webNaviBarSelectIndex:selectedIndex];
    }
    
    UIButton *selectedBtn = _btnList[selectedIndex];
    
    for (UIButton *btn in _btnList) {
        btn.selected = btn == selectedBtn;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectedLine.centerX = selectedBtn.centerX;
    }];
}

#pragma mark -action
- (void)btnClicked:(UIButton *)sender
{
    if (![self.btnList containsObject:sender]) {
        return;
    }
    
    NSInteger selectedIndex = [self.btnList indexOfObject:sender];
    
    self.selectedIndex = selectedIndex;
}

#pragma mark -ui
- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        _topLine.backgroundColor = HEX_RGB(@"#ECECEC");
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)selectedLine
{
    if (!_selectedLine) {
        CGFloat h = 2;
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-h, 0, h)];
        [self addSubview:_selectedLine];
    }
    return _selectedLine;
}

- (NSMutableArray<UIButton *> *)btnList
{
    if (!_btnList) {
        _btnList = [NSMutableArray array];
    }
    return _btnList;
}

@end
