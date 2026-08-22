//
//  StatsMonthViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsMonthViewController.h"
#import "FinanceView.h"
#import "YearModel.h"
#import "StatsViewModel.h"
#import "StatsMonthCell.h"
#import "RecordDetailViewController.h"

@interface StatsMonthViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FinanceView *financeView;

@end

@implementation StatsMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setMonth:(MonthModel *)month
{
    _month = month;
    
    if (month.yearModel.isFollowing) {
        self.title = @"进行中";
    }else {
        self.title = [NSString stringWithFormat:@"%@%@", month.yearModel.title, month.title];
    }
    
    [self.tableView reloadData];
    self.financeView.models = [StatsViewModel getFinanceModelsFromMonth:month];

}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _month.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatsMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMCellId forIndexPath:indexPath];
    
    [cell update:_month index:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _month.records.count) {
        RecordModel *record = _month.records[indexPath.row];
        RecordDetailViewController *vc = [RecordDetailViewController new];
        [vc setRecord:record canEdit:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
        _tableView.backgroundColor = GRAY_BG_COLOR;
        _tableView.rowHeight = kSMCellH;
        [_tableView registerClass:StatsMonthCell.class forCellReuseIdentifier:kSMCellId];
        
        [self.view addSubview:_tableView];
        
        //topview
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        _tableView.tableHeaderView = topView;
        
        CGFloat edge = 15;
        _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(edge, 0, topView.width-edge*2, topView.height-15)];


        [topView addSubview:_financeView];
    }
    return _tableView;
}

@end
