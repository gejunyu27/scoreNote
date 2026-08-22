//
//  StatsYearViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsYearViewController.h"
#import "FinanceView.h"
#import "YearModel.h"
#import "StatsViewModel.h"
#import "StatsYearHeaderView.h"
#import "StatsYearCell.h"
#import "RecordDetailViewController.h"

@interface StatsYearViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FinanceView *financeView;

@end

@implementation StatsYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -data
- (void)setYear:(YearModel *)year
{
    _year = year;
    self.title = year.title;
    [self.tableView reloadData];
    
    self.financeView.models = [StatsViewModel getFinanceModelsFromYear:year];

}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _year.monthModels.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StatsYearHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSYHeaderId];
    
    if (section < _year.monthModels.count) {
        header.month = _year.monthModels[section];
        @weakify(self)
        header.clickBlock = ^{
            @strongify(self)
            [self.tableView reloadData];
        };
    }
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _year.monthModels.count) {
        MonthModel *month = _year.monthModels[section];
        
        return month.isOn ? month.records.count : 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatsYearCell *cell = [tableView dequeueReusableCellWithIdentifier:kSYCellId];
    
    RecordModel *record = [self getRecordAtIndexPath:indexPath];
    
    if (record) {
        [cell update:record row:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordModel *record = [self getRecordAtIndexPath:indexPath];
    
    if (record) {
        RecordDetailViewController *vc = [RecordDetailViewController new];
        [vc setRecord:record canEdit:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (RecordModel *)getRecordAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section < _year.monthModels.count) {
        MonthModel *month = _year.monthModels[section];
        
        NSInteger row = indexPath.row;
        if (row < month.records.count) {
            RecordModel *record = month.records[row];
            return record;
        }
    }

    return nil;
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
        [_tableView registerClass:StatsYearHeaderView.class forHeaderFooterViewReuseIdentifier:kSYHeaderId];
        _tableView.sectionHeaderHeight = kSYHeaderH;
        _tableView.rowHeight = kSYCellH;
        [_tableView registerClass:StatsYearCell.class forCellReuseIdentifier:kSYCellId];
        
        [self.view addSubview:_tableView];
        
        //topview
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        _tableView.tableHeaderView = topView;
        
        CGFloat edge = 15;
        _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(edge, 0, topView.width-edge*2, topView.height-5)];

        [topView addSubview:_financeView];
    }
    return _tableView;
}

@end
