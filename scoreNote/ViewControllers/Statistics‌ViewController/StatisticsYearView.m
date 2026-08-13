//
//  StatisticsYearView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/6.
//

#import "StatisticsYearView.h"

@interface StatisticsYearView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnList;
@end

@implementation StatisticsYearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        [self setCommonShadow];
    }
    return self;
}

#pragma mark -public
- (void)update:(NSArray<YearModel *> *)yearModels
{
    //先创建按钮
    NSInteger count = yearModels.count;
    [self createButtons:count];
    
    CGFloat edge = 10;
    CGFloat w = (self.scrollView.width-edge*2)/4; //一页最多显示4个
    self.selectedLine.width = w-20;
    for (int i=0; i<count; i++) {
        UIButton *btn = self.btnList[i];
        btn.frame = CGRectMake(edge+w*i, 0, w, self.scrollView.height);
        YearModel *year = yearModels[i];
        [btn setTitle:year.title forState:UIControlStateNormal];
    }
    self.scrollView.contentSize = CGSizeMake(edge*2+w*count, self.scrollView.height);
    
    self.selectedIndex = _selectedIndex;
    self.selectBlock(self.selectedIndex);
    
}

- (void)createButtons:(NSInteger)count
{
    //少加，多减，避免反复刷新反复删除和新建按钮
    if (count > self.btnList.count) { //补齐少的按钮
        NSInteger addNum = count - self.btnList.count;
        for (int i=0; i<addNum; i++) {
            UIButton *btn = [UIButton new];
            [btn setTitleColor:HEX_RGB(@"#6E6E6E") forState:UIControlStateNormal];
            [btn setTitleColor:self.selectedLine.backgroundColor forState:UIControlStateSelected];
            btn.titleLabel.font = SCFONT_SIZED(19);
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
            [self.btnList addObject:btn];
        }
        
    }else if (count < self.btnList.count) { //删掉多的按钮
        [self.btnList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= count) {
                [btn removeFromSuperview];
                [self.btnList removeObject:btn];
            }
        }];
    }

}

#pragma mark -action
- (void)btnClicked:(UIButton *)sender
{
    if (![self.btnList containsObject:sender]) {
        return;
    }
    
    NSInteger index = [self.btnList indexOfObject:sender];
    
    if (_selectedIndex == index) {
        return;
    }
    
    self.selectedIndex = index;
    
    self.selectBlock(self.selectedIndex);
}

#pragma mark -set&get
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_btnList.count <= 0) {
        return;
    }
    
    if (selectedIndex < 0) {
        selectedIndex = 0;
        
    }else if (selectedIndex >= self.btnList.count) {
        selectedIndex = self.btnList.count - 1;
    }

    _selectedIndex = selectedIndex;
    
    for (int i=0; i<self.btnList.count; i++) {
        UIButton *btn = self.btnList[i];
        btn.selected = i==_selectedIndex;
        if (btn.selected) {
            self.selectedLine.centerX = btn.centerX;
        }
    }
}

#pragma mark -ui
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)selectedLine
{
    if (!_selectedLine) {
        CGFloat h = 2;
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-h-2, 0, h)];
        _selectedLine.backgroundColor = HEX_RGB(@"#DF3F27");
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
