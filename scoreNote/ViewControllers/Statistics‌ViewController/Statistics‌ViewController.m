//
//  Statistics‌ViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/6.
//

#import "Statistics‌ViewController.h"
#import "Statistics‌ViewModel.h"
#import "FinanceView.h"
#import "StatisticsCalendarView.h"
#import "TagViewController.h"
#import "CareerViewController.h"
#import "ConfigViewController.h"

@interface StatisticsViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) StatisticsCalendarView *calendarView;
@property (nonatomic, strong) StatisticsViewModel *viewModel;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bgView];
    //暂时先这么写，以后有3个卡片就要更改代码
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, SCREEN_HEIGHT-SCROLL_SAFE_TOP-TAB_BAR_HEIGHT+10);
    
    [self refreshUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.viewModel.needUpdate) {
        //因为订单变动频繁，所以不每次接收通知都更新数据，只在打开此页面时更新一次
        [self.viewModel update];
        [self refreshUI];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setNaviTitleColor:nil];
}

- (void)refreshUI
{
    //金融界面
    self.financeView.models = self.viewModel.financeModels;

    //月份图
    self.calendarView.yearModels = self.viewModel.yearModels;

}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.titleTextAttributes = nil;
    
    CGFloat offset = scrollView.contentOffset.y+SCROLL_SAFE_TOP; //默认偏移-116 上滑增加 下拉减小
    
    [self setNaviTitleColor:offset<=30 ? [UIColor whiteColor] : [UIColor blackColor]];
}

- (void)setNaviTitleColor:(UIColor *)color
{
    self.navigationController.navigationBar.titleTextAttributes = color ? @{NSForegroundColorAttributeName:color} : nil;
}

#pragma mark -action
- (void)tagClicked
{
    [self.navigationController pushViewController:[TagViewController new] animated:YES];
}

- (void)careerClicked
{
    [self showWithStatus:@"功能更新中"];
//    CareerViewController *vc = [CareerViewController new];
//    [vc setSectionList:self.viewModel.sectionList startRecord:self.viewModel.startRecord];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configClick
{
    ConfigViewController *vc = [ConfigViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UI
#define kHorEdge 15
#define kVerEdge 20

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        //新版
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT;
        if (@available(iOS 26.0, *)) {
            //ios26不减导航栏高度，否则会出错，原因未知 tabbar高度可减可不减。减了底部正好在tabbar上方，不减和毛玻璃效果适配'
            //            h = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
            h = SCREEN_HEIGHT; //这里不减，视觉效果最好
        }
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = DEFAULT_BG_COLOR;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        //顶部加个颜色
        //y为0的话，起始位置是在116。所以先设-116，保证视觉上可以顶在最上面
        //在实际使用过程中，下拉会把上面的白色露出来，不是很好看，为了美观再加300的高度
        CGFloat extraH = 200;
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCROLL_SAFE_TOP-extraH, self.scrollView.width, 280+extraH)];
//        _bgView.backgroundColor = HEX_RGB(@"#1A77DD");
        [_bgView setGradientColorWithTopColor:HEX_RGB(@"#1A77DD") bottomColor:HEX_RGB(@"#6CB2F7")];
//        [self.view addSubview:_bgView];
        [self.scrollView addSubview:_bgView];
    }
    return _bgView;
}

- (FinanceView *)financeView
{
    if (!_financeView) {
        CGFloat x = kHorEdge;
        _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(x, 0, self.scrollView.width-x*2, 220)];
        
        [_financeView addFunctionButtonWithImage:@"Config" target:self action:@selector(configClick) forControlEvents:UIControlEventTouchUpInside];
        [_financeView addFunctionButtonWithImage:@"Carrer" target:self action:@selector(careerClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_financeView];
    }
    return _financeView;
}

- (StatisticsCalendarView *)calendarView
{
    if (!_calendarView) {
        CGFloat x = kHorEdge;
        _calendarView = [[StatisticsCalendarView alloc] initWithFrame:CGRectMake(x, self.financeView.bottom + kVerEdge, self.scrollView.width-x*2, 320)];
        [self.scrollView addSubview:_calendarView];
    }
    return _calendarView;
}

- (StatisticsViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [StatisticsViewModel new];
    }
    return _viewModel;
}
@end
