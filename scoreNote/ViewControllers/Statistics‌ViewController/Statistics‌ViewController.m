//
//  Statistics‌ViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/6.
//

#import "Statistics‌ViewController.h"
#import "Statistics‌ViewModel.h"
#import "TagViewController.h"
#import "ConfigViewController.h"
#import "StatisticsHeaderView.h"

#define kHeaderY 0

@interface StatisticsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, StatisticsHeaderDelegate>
@property (nonatomic, strong) StatisticsHeaderView *headerView;
@property (nonatomic, strong) StatisticsViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <UITableView *> *tableList;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //第一个可能没用，第二个设了有效果，是让y=0起点从导航栏下方开始。
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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

- (void)refreshUI
{
    //先创建table
    NSArray *yearModels = self.viewModel.yearModels;
    [self createTableList:yearModels.count];

    //年份 金融界面
    [self.headerView updateWithFinanceModels:self.viewModel.financeModels yearModels:yearModels];
    
    //刷新列表
    for (UITableView *tableView in self.tableList) {
        [tableView reloadData];
    }
    
}

- (void)createTableList:(NSInteger)count
{
    //少加，多减，避免反复刷新反复删除和新建列表
    CGFloat w = self.scrollView.width;
    CGFloat h = self.scrollView.height;
    
    if (count > self.tableList.count) { //补齐少的列表
        NSInteger addNum = count - self.tableList.count;
        for (int i=0; i<addNum; i++) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.sectionHeaderTopPadding = 0;
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.backgroundColor = [UIColor clearColor];
            [self.scrollView addSubview:tableView];
            [self.tableList addObject:tableView];
            
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, kHeaderY + self.headerView.height)];
            tableView.tableHeaderView = topView;
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, NAV_BAR_HEIGHT)];
            tableView.tableFooterView = footerView;
        }
        
    }else if (count < self.tableList.count) { //删掉多的列表
        [self.tableList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UITableView * _Nonnull tableView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= count) {
                [tableView removeFromSuperview];
                [self.tableList removeObject:tableView];
            }
        }];
    }
    

    for (int i=0; i<count; i++) {
        UITableView *tableView = self.tableList[i];
        tableView.left = i*w;
    }
    self.scrollView.contentSize = CGSizeMake(count*w, 0);

}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    YearModel *year = [self getYear:tableView];
    return year.monthModels.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MonthModel *month = [self getMonth:tableView section:section];
    
    return month.title ?: @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MonthModel *month = [self getMonth:tableView section:section];
    
    return month.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    RecordModel *record = [self getRecord:tableView indexPath:indexPath];
    if (record) {
        cell.textLabel.text = record.tagModel.name;
    }

    return cell;
}

- (YearModel *)getYear:(UITableView *)tableView
{
    if ([self.tableList containsObject:tableView]) {
        NSInteger index = [self.tableList indexOfObject:tableView];
        if (index < self.viewModel.yearModels.count) {
            YearModel *year = self.viewModel.yearModels[index];
            return year;
        }
        
    }
    
    return nil;
}

- (MonthModel *)getMonth:(UITableView *)tableView section:(NSInteger)section
{
    YearModel *year = [self getYear:tableView];
    
    if (year) {
        if (section < year.monthModels.count) {
            MonthModel *month = year.monthModels[section];
            return month;
        }
    }
    
    return nil;
}

- (RecordModel *)getRecord:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    MonthModel *month = [self getMonth:tableView section:indexPath.section];
    
    if (indexPath.row < month.records.count) {
        RecordModel *record = month.records[indexPath.row];
        return record;
    }
    
    return nil;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:UITableView.class]) {
        return;
    }
    
    UITableView *table = (UITableView *)scrollView;
    CGFloat offsetY = table.contentOffset.y;  //向上滑增大 下拉减小
    // 同步所有table偏移
    for (UITableView *t in self.tableList) {
        if(t != table) t.contentOffset = CGPointMake(0, offsetY);
    }
    
    // 移动顶层topView 如果需要吸顶，就设个最小值
    self.headerView.top = kHeaderY - offsetY;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat pageW = scrollView.width;
    NSInteger index = offsetX / pageW;
    index = MAX(0, MIN(index, self.tableList.count - 1));
    
    // 执行切换页面逻辑
    self.headerView.selectedIndex = index;
}

#pragma mark -StatisticsHeaderDelegate
- (void)statisticsHeaderYearSelected:(NSInteger)index
{
    if (index < 0 || index >= self.tableList.count) {
        return;
    }
    
    //滑动
    [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.width, 0) animated:YES];
    
}

#pragma mark -action
- (void)tagClicked:(UIButton *)sender
{
    [self.navigationController pushViewController:[TagViewController new] animated:YES];
}

- (void)careerClicked:(UIButton *)sender
{
//    if (!self.viewModel.startRecord) {
//        [self showWithStatus:@"还未起投"];
//        return;
//    }
//    
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
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        //新版
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = DEFAULT_BG_COLOR;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        [self.view insertSubview:_scrollView belowSubview:self.headerView];
        
    }
    return _scrollView;
}

- (StatisticsHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[StatisticsHeaderView alloc] initWithFrame:CGRectMake(0, kHeaderY, SCREEN_WIDTH, 250)];
        _headerView.delegate = self;
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

- (NSMutableArray<UITableView *> *)tableList
{
    if (!_tableList) {
        _tableList = [NSMutableArray array];
    }
    return _tableList;
}

- (StatisticsViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [StatisticsViewModel new];
    }
    return _viewModel;
}
@end
