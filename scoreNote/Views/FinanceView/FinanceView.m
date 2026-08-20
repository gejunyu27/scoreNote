//
//  FinanceView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import "FinanceView.h"
#import "FinanceButton.h"
#import <AAChartKit/AAChartKit.h>

@interface FinanceView ()
@property (nonatomic, strong) NSArray <FinanceButton *> *financeButtonList; //展示的
@property (nonatomic, strong) NSMutableArray <UIButton *> *functionButtonList; //右上角的按钮

@property (nonatomic, strong) UIControl *chartButton;
@property (nonatomic, strong) AAChartView *chartView; //折线图
@end

@implementation FinanceView

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

#pragma mark -init
- (void)initUI
{
    NSInteger count = self.models.count;
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:count];
    
    CGFloat horEdge = 15;
    FinanceButton *headerButton = [[FinanceButton alloc] initWithFrame:CGRectMake(horEdge, 15, 200, 60)];
    [headerButton largerSize];
    headerButton.userInteractionEnabled = NO; //目前先不加点击事件
    [self addSubview:headerButton];
    
    [temp addObject:headerButton];
    
    //1排两个，剩下按钮占几排
    NSInteger lines = (count-1)/2;
    CGFloat btnH = 50;
    CGFloat verEdge = 10;
    CGFloat y = self.height - btnH*lines - verEdge*lines;
    CGFloat w = (self.width-horEdge*2)/2;
    
    for (int i=0; i<count-1; i++) {
        FinanceButton *btn = [[FinanceButton alloc] initWithFrame:CGRectMake(horEdge+w*(i%2), y+(btnH+verEdge)*(i/2), w, btnH)];
        [self addSubview:btn];
        [temp addObject:btn];
        btn.userInteractionEnabled = NO; //目前先不加点击事件
    }
    
    _financeButtonList = temp.copy;
    
    //下划线
    if (lines > 0) {
        CGFloat lineH = 0.5;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(horEdge, y-10-lineH, self.width-horEdge*2, lineH)];
        line.backgroundColor = HEX_RGB(@"#AEAEAE");
        line.alpha = 0.6;
        [self addSubview:line];
    }
}

#pragma mark -data
- (void)setModels:(NSArray<FinanceModel *> *)models
{
    _models = models;
    
    if (models.count == 0) {
        return;
    }
    
    if (!_financeButtonList) {
        [self initUI];
    }
    
    [models enumerateObjectsUsingBlock:^(FinanceModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.financeButtonList.count) {
            FinanceButton *btn = self.financeButtonList[idx];
            btn.model = model;
        }
    }];
    
}

- (void)setMonthProfitList:(NSArray<NSNumber *> *)monthProfitList
{
    if (!monthProfitList) {
        return;
    }
    
    AAChartModel *aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypeAreaspline)//设置图表的类型(填充曲线图)
//        .titleSet(@"编程语言热度")//设置图表标题
//        .subtitleSet(@"虚拟数据")//设置图表副标题
//        .categoriesSet(@[@"1",@"2",@"3",@"4", @"5",@"6",@"7",@"8"])//图表横轴的内容
//        .yAxisTitleSet(@"¥")//设置图表 y 轴的单位
//        .xAxisLabelsEnabledSet(NO) //X 轴是否显示文字
//        .yAxisLabelsEnabledSet(NO) //y 轴是否显示文字
    .yAxisVisibleSet(NO)   //隐藏y轴
    .xAxisVisibleSet(NO)   //隐藏x轴
    .legendEnabledSet(NO)  //隐藏下方标识
    .tooltipEnabledSet(NO) //隐藏浮动框
    .markerRadiusSet(@0)   //连接点半径 默认5  0等于不显示
    .colorsThemeSet(@[@"#80A8D8"])
    .seriesSet(@[
        AASeriesElement.new
//                .nameSet(@"2017")
        .lineWidthSet(@1.8) //线宽度
//            .colorSet((id)[AAGradientColor gradientColorWithDirection:AALinearGradientDirectionToRight
//                                                           stopsArray:@[
//                                                               @[@0.00, @"#febc0f"],//颜色字符串设置支持十六进制类型和 rgba 类型
//                                                               @[@0.25, @"#FF14d4"],
//                                                               @[@0.50, @"#0bf8f5"],
//                                                               @[@0.75, @"#F33c52"],
//                                                               @[@1.00, @"#1904dd"],
//                                                           ]]) //折线的渐变色
            .colorSet(AARgbaColor(36, 136, 237, 1.0))//线条：主蓝色#2488ED，不透明
            .fillColorSet((id)[AAGradientColor gradientColorWithDirection:AALinearGradientDirectionToBottom
                                                         startColorString:AARgbaColor(36, 136, 237, 0.35)//靠近曲线：蓝色，透明度0.35
                                                           endColorString:AARgbaColor(36, 136, 237, 0.02)])//底部：同蓝色，几乎完全透明 //下方透明区域渐变色
            .dataSet(monthProfitList)
//            AASeriesElement.new
//                .nameSet(@"2018")
//                .dataSet(@[@0.2, @0.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1, @14.1, @8.6, @2.5]),
//            AASeriesElement.new
//                .nameSet(@"2019")
//                .dataSet(@[@0.9, @0.6, @3.5, @8.4, @13.5, @17.0, @18.6, @17.9, @14.3, @9.0, @3.9, @1.0]),
//            AASeriesElement.new
//                .nameSet(@"2020")
//                .dataSet(@[@3.9, @4.2, @5.7, @8.5, @11.9, @15.2, @17.0, @16.6, @14.2, @10.3, @6.6, @4.8]),
    ]);
    
    
    if (!_chartView) { //首次加载
        [self.chartView aa_drawChartWithChartModel:aaChartModel];
        
    }else {
        [self.chartView aa_refreshChartWithChartModel:aaChartModel];
    }
    
}


#pragma mark -publick
//添加右侧按钮 写法1
- (void)addFunctionButtonWithImage:(id)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn = [self addFunctionButtonWithImage:image];
    [btn addTarget:target action:action forControlEvents:controlEvents];

}

//添加右侧按钮 写法2
- (void)addFunctionButtonWithImage:(id)image eventHandler:(nonnull void (^)(id _Nonnull))handler
{
    UIButton *btn = [self addFunctionButtonWithImage:image];
    [btn sc_addEventTouchUpInsideHandle:handler];
}

- (UIButton *)addFunctionButtonWithImage:(id)image
{
    CGFloat btnWH   = 30;
    CGFloat btnEdge = 20;
    
    //第几个按钮
    NSInteger index = self.functionButtonList.count;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - (btnEdge+btnWH)*(index+1), 20, btnWH, btnWH)];
    
    if ([image isKindOfClass:UIImage.class]) {
        [btn setImage:image forState:UIControlStateNormal];
        
    }else if ([image isKindOfClass:NSString.class]) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [self addSubview:btn];
    [self.functionButtonList addObject:btn];
    
    return btn;
}

#pragma mark -action
- (void)chartClicked
{
    if ([self.delegate respondsToSelector:@selector(financeViewChartClicked)]) {
        [self.delegate financeViewChartClicked];
    }
}

#pragma mark -ui
- (NSMutableArray<UIButton *> *)functionButtonList
{
    if (!_functionButtonList) {
        _functionButtonList = [NSMutableArray array];
    }
    return _functionButtonList;
}

- (UIControl *)chartButton
{
    if (!_chartButton) {
        CGFloat w = self.width/2;
        CGFloat h = 70;
        _chartButton = [[UIControl alloc] initWithFrame:CGRectMake(self.width-w, 15, w, h)];
        [_chartButton addTarget:self action:@selector(chartClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chartButton];
        [self sendSubviewToBack:_chartButton];
        
        //箭头
        CGFloat iconWh = 16;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(w-iconWh-10, (h-iconWh)/2, iconWh, iconWh)];
        icon.image = [UIImage imageNamed:@"RightArrow"];
        [_chartButton addSubview:icon];
    }
    return _chartButton;
}

- (AAChartView *)chartView
{
    if (!_chartView) {
        //折线图
        _chartView = [[AAChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartButton.width-30, self.chartButton.height)];
        _chartView.userInteractionEnabled = NO;
        [self.chartButton addSubview:_chartView];
        
    }
    return _chartView;
}

@end
