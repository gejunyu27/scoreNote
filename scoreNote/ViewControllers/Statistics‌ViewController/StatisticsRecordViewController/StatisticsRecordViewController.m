//
//  StatisticsRecordViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import "StatisticsRecordViewController.h"
#import "FinanceView.h"
#import "StatisticsRecordHeaderView.h"
#import "StatisticsRecordCell.h"

#define kIsYear (_year!=nil)

@interface StatisticsRecordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FinanceView *financeView;

@end

@implementation StatisticsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setYear:(YearModel *)year
{
    _year = year;
    self.title = year.title;
    [self.tableView reloadData];
    self.financeView.models = [self getFinanceModelsFromYear:year];

}

- (void)setMonth:(MonthModel *)month
{
    _month = month;
    self.title = [NSString stringWithFormat:@"%@%@", month.yearModel.title, month.title];
    [self.tableView reloadData];
    self.financeView.models = [self getFinanceModelsFromMonth:month];

}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  kIsYear ? _year.monthModels.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kIsYear ? kSRHeaderH : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (kIsYear) {
        StatisticsRecordHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSRHeaderId];
        if (section < _year.monthModels.count) {
            MonthModel *month = _year.monthModels[section];
            header.month = month;
            @weakify(self)
            header.clickBlock = ^{
                @strongify(self)
                [self.tableView reloadData];
            };
        }
        
        return header;
    }
    
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (kIsYear) {
        if (section < _year.monthModels.count) {
           MonthModel *month = _year.monthModels[section];
            return month.isOn ? month.records.count : 0;
        }
        
        return 0;
        
    }else {
        return _month.records.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticsRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kSRCellId forIndexPath:indexPath];
    
    MonthModel *month = _month;
    
    if (kIsYear) {
        if (indexPath.section < _year.monthModels.count) {
            month = _year.monthModels[indexPath.section];
        }
    }
    
    if (indexPath.row < month.records.count) {
        RecordModel *record = month.records[indexPath.row];
        [cell update:record isYear:kIsYear row:indexPath.row];
    }
    
    
    return cell;
}

//详情页两个功能
- (NSArray <FinanceModel *> *)getFinanceModelsFromYear:(YearModel *)year
{
    //利润
    FinanceModel *profitModel = [[FinanceModel alloc] initWithTitle:(year.isFollowing ? @"投入状况" : @"本年利润") content:[SCUtilities removeFloatSuffix:year.allProfit]];
    
    //支出
    FinanceModel *outModel = [[FinanceModel alloc] initWithTitle:@"支出" content:[SCUtilities removeFloatSuffix:year.allOut]];
    
    //收入
    FinanceModel *getModel = [[FinanceModel alloc] initWithTitle:@"收入" content:[SCUtilities removeFloatSuffix:year.allGet]];
    
    return @[profitModel, outModel , getModel];
}

- (NSArray <FinanceModel *> *)getFinanceModelsFromMonth:(MonthModel *)month
{
    //利润
    FinanceModel *profitModel = [[FinanceModel alloc] initWithTitle:(month.yearModel.isFollowing ? @"投入状况" : @"本月利润") content:[SCUtilities removeFloatSuffix:month.allProfit]];
    
    //支出
    FinanceModel *outModel = [[FinanceModel alloc] initWithTitle:@"支出" content:[SCUtilities removeFloatSuffix:month.allOut]];
    
    //收入
    FinanceModel *getModel = [[FinanceModel alloc] initWithTitle:@"收入" content:[SCUtilities removeFloatSuffix:month.allGet]];
    
    return @[profitModel, outModel , getModel];
}

#pragma mark -UI
- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT;
        if (@available(iOS 26.0, *)) {
            //ios26不减导航栏高度，否则会出错，原因未知 tabbar高度可减可不减。减了底部正好在tabbar上方，不减和毛玻璃效果适配'
            //            h = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
            h = SCREEN_HEIGHT; //这里不减，视觉效果最好
        }
        
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderTopPadding = 0;
        [_tableView registerClass:StatisticsRecordHeaderView.class forHeaderFooterViewReuseIdentifier:kSRHeaderId];
        _tableView.rowHeight = kSRCellH;
        [_tableView registerClass:StatisticsRecordCell.class forCellReuseIdentifier:kSRCellId];
        
        [self.view addSubview:_tableView];
        
        //topview
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
        _tableView.tableHeaderView = topView;
        
        CGFloat edge = 15;
        _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(edge, 0, topView.width-edge*2, topView.height-5)];


        [topView addSubview:_financeView];
    }
    return _tableView;
}

@end
