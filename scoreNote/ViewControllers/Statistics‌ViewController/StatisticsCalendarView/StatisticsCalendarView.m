//
//  StatisticsCalendarView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/16.
//

#import "StatisticsCalendarView.h"
#import "SwitchYearView.h"
#import "CalendarDateItem.h"

@interface StatisticsCalendarView () <SwitchYearViewDelegate>
@property (nonatomic, strong) NSArray <UIButton *> *categoryButtonList; //月收益 年收益
@property (nonatomic, strong) SwitchYearView *switchView;
@property (nonatomic, strong) NSArray <CalendarDateItem *> *itemList;

@end

@implementation StatisticsCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        self.backgroundColor = [UIColor whiteColor];
        [self setCommonShadow];
        [self categoryButtonList];
    }
    return self;
}

#pragma mark -data
- (void)setYearModels:(NSArray<YearModel *> *)yearModels
{
    _yearModels = yearModels;
    
    NSInteger count = yearModels.count;
    
    NSInteger yearIndex = count-1;
    if (yearModels.count > 1) {
        YearModel *lastModel = yearModels.lastObject;
        if (lastModel.isFollowing) {
            yearIndex = yearModels.count-2; //如果最后一个是“进行中”，则从倒数第二个带年份的开始展示
        }
    }
    
    [self refreshUI:yearIndex];
}

- (void)refreshUI:(NSInteger)yearIndex
{
    //分类  0 月份  1年份
    NSInteger categotyIndex = self.categoryButtonList.firstObject.selected ? 0 : 1;
    BOOL isShowYearData = categotyIndex;
    
    //切换年份按钮
    [self.switchView refresh:_yearModels];
    self.switchView.selectedIndex = yearIndex;
    self.switchView.hidden = isShowYearData;
    
    //展示年份
    if (isShowYearData) {
        //开始刷新年份
        [self refreshDateItems:_yearModels isShowYear:YES];
        
        return;
    }
    
    //展示月份
    if (yearIndex < 0 || yearIndex >= _yearModels.count) {
        return;
    }
    
    YearModel *currentYear = _yearModels[yearIndex];
    //开始刷新月份
    [self refreshDateItems:currentYear.monthModels isShowYear:NO];

}

- (void)refreshDateItems:(NSArray *)models isShowYear:(BOOL)isShowYear
{
    for (int i=0; i<self.itemList.count; i++) {
        CalendarDateItem *item = self.itemList[i];
        if (i<models.count) {
            item.hidden = NO;
            if (isShowYear) {
                YearModel *year = models[i];
                item.year = year;
                
            }else {
                MonthModel *month = models[i];
                item.month = month;
            }
            
        }else {
            item.hidden = YES;
        }
    }
}

#pragma mark -action
- (void)categoryClicked:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }

    for (UIButton *btn in _categoryButtonList) {
        btn.selected = btn == sender;
        btn.titleLabel.font = btn.selected ? SCFONT_BOLD_SIZED(19) : SCFONT_BOLD_SIZED(17);
    }
        
    if (_yearModels.count > 0) {
        [self refreshUI:self.switchView.selectedIndex];
    }
    
}

- (void)itemClicked:(CalendarDateItem *)sender
{
    if (![self.itemList containsObject:sender]) {
        return;
    }
    
    //跳转
    
}

#pragma mark -SwitchYearViewDelegate
- (void)switchYearViewSelected:(NSInteger)index
{
    [self refreshUI:index];
}

#pragma mark -ui
#define kEdge 15
- (NSArray<UIButton *> *)categoryButtonList
{
    if (!_categoryButtonList) {
        NSArray *titles = @[@"月收益", @"年收益"];
        NSMutableArray *temp = [NSMutableArray array];
        CGFloat w = 60;
        for (int i=0; i<titles.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15+(w+20)*i, 10, w, 50)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(categoryClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [btn setTitleColor:HEX_RGB(@"#7F7F7F") forState:UIControlStateNormal];
            [self addSubview:btn];
            [temp addObject:btn];
        }
        
        _categoryButtonList = temp.copy;
        
        [self categoryClicked:temp.firstObject]; //点击第一个

    }
    return _categoryButtonList;
}

- (SwitchYearView *)switchView
{
    if (!_switchView) {
        CGFloat w = 140;
        _switchView = [[SwitchYearView alloc] initWithFrame:CGRectMake(self.width-kEdge-w, 18, w, 35)];
        _switchView.delegate = self;
        [self addSubview:_switchView];
    }
    return _switchView;
}

- (NSArray<CalendarDateItem *> *)itemList
{
    if (!_itemList) {
        NSMutableArray *temp = [NSMutableArray array];
        
        CGFloat margin = 10;
        NSInteger lineNum = 4; //一排4个
        CGFloat w = (self.width-kEdge*2-margin*(lineNum-1))/lineNum;
        CGFloat h = w*0.9;
        CGFloat y = self.switchView.bottom + 25;
        
        for (int i=0; i<12; i++) {
            CalendarDateItem *item = [[CalendarDateItem alloc] initWithFrame:CGRectMake(kEdge+(w+margin)*(i%lineNum), y+(h+margin)*(i/lineNum), w, h)];
            [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            [temp addObject:item];
        }
        _itemList = temp.copy;
    }
    return _itemList;
}

@end
