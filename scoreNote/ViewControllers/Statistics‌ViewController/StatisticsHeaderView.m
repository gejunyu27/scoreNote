//
//  StatisticsHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/11.
//

#import "StatisticsHeaderView.h"
#import "FinanceView.h"
#import "StatisticsYearView.h"

@interface StatisticsHeaderView ()
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) StatisticsYearView *yearView;
@end

@implementation StatisticsHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    CGFloat edge = 15;
    _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(edge, 0, self.width-edge*2, 180)];
    [_financeView addFunctionButtonWithImage:@"Config" target:self action:@selector(configClick) forControlEvents:UIControlEventTouchUpInside];
    [_financeView addFunctionButtonWithImage:@"Tag" target:self action:@selector(tagClicked) forControlEvents:UIControlEventTouchUpInside];
    [_financeView addFunctionButtonWithImage:@"Carrer" target:self action:@selector(careerClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_financeView];
    
    CGFloat y = _financeView.bottom + 10;
    CGFloat h = self.height - y - 15;
    _yearView = [[StatisticsYearView alloc] initWithFrame:CGRectMake(edge, y, self.width-edge*2, h)];
    
    @weakify(self)
    _yearView.selectBlock = ^(NSInteger index) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(statisticsHeaderYearSelected:)]) {
            [self.delegate statisticsHeaderYearSelected:index];
        }
    };
    [self addSubview:_yearView];
}

#pragma mark -set&get
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.yearView.selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex
{
    return self.yearView.selectedIndex;
}

#pragma mark -public
- (void)updateWithFinanceModels:(NSArray<FinanceModel *> *)financeModels yearModels:(nonnull NSArray<YearModel *> *)yearModels
{
    self.financeView.models = financeModels;
    
    [self.yearView update:yearModels];
    
}

#pragma mark -action
- (void)configClick
{
    
}

- (void)tagClicked
{
    
}

- (void)careerClicked
{
    
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    // 如果点击区域内没有可交互控件（按钮、输入框），手势穿透到下层tableView
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

@end
