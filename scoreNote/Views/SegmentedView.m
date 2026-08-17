//
//  SegmentedView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/16.
//

#import "SegmentedView.h"

@interface SegmentedView ()
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnList;
@property (nonatomic, strong) UIView *selectedView;
@end

@implementation SegmentedView

- (instancetype)initWithFrame:(CGRect)frame titles:(nonnull NSArray<NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_RGB(@"#EEEEEE");
        [self initUI:titles];
        self.isCircle = YES;
    }
    return self;
}

- (void)initUI:(NSArray<NSString *> *)titles
{
    CGFloat btnW = self.width/titles.count;
    
    //按钮
    _btnList = [NSMutableArray array];

    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, self.height)];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:HEX_RGB(@"#565656") forState:UIControlStateNormal];
        btn.titleLabel.font = SCFONT_SIZED(14);
        btn.selected = i==0;
        [self addSubview:btn];
        [self.btnList addObject:btn];
    }
    
    //选中方块
    CGFloat edge = 3;
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(edge, edge, btnW-edge*2, self.height-edge*2)];
    _selectedView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_selectedView];
    [self sendSubviewToBack:_selectedView];
    

}

#pragma mark -action
- (void)btnClicked:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    for (UIButton *btn in self.btnList) {
        if (btn == sender) {
            btn.selected = YES;
            _selectedIndex = [self.btnList indexOfObject:btn];
            [UIView animateWithDuration:0.2 animations:^{
                self.selectedView.centerX = btn.centerX;
            }];
            
        }else {
            btn.selected = NO;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedViewSelected:)]) {
        [self.delegate segmentedViewSelected:_selectedIndex];
    }
    
    if (_selectedBlock) {
        _selectedBlock(_selectedIndex);
    }
}


#pragma mark -public
- (void)setIsCircle:(BOOL)isCircle
{
    self.layer.cornerRadius = isCircle ? self.height/2 : 0;
    self.selectedView.layer.cornerRadius = isCircle ? self.selectedView.height/2 : 0;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    self.selectedView.backgroundColor = selectedColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    for (UIButton *btn in self.btnList) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    for (UIButton *btn in self.btnList) {
        [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

- (void)setFont:(UIFont *)font
{
    for (UIButton *btn in self.btnList) {
        btn.titleLabel.font = font;
    }
}


@end
