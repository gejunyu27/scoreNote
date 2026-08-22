//
//  StatsReportViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsReportViewController.h"
#import "StatsReportViewModel.h"
#import "StatsReportCell.h"
#import "RecordDetailViewController.h"

@interface StatsReportViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StatsReportViewModel *viewModel;

@end

@implementation StatsReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报告";
}

#pragma mark -data
- (void)getDataFrom:(StatsViewModel *)statsViewModel
{
    [self.viewModel getDataFrom:statsViewModel];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.reportList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatsReportCell *cell = [tableView dequeueReusableCellWithIdentifier:kSRCellId forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    NSArray *reportList = self.viewModel.reportList;
    if (row < reportList.count) {
        StatsReportModel *report = reportList[row];
        [cell update:report row:row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *reportList = self.viewModel.reportList;
    
    if (row < reportList.count) {
        StatsReportModel *report = reportList[row];
        
        if (report.record) {
            RecordDetailViewController *vc = [RecordDetailViewController new];
            [vc setRecord:report.record canEdit:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -UI
- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT;
        if (@available(iOS 26.0, *)) {
            h = SCREEN_HEIGHT;
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.rowHeight = kSRCellH;
        [_tableView registerClass:StatsReportCell.class forCellReuseIdentifier:kSRCellId];
        _tableView.sectionHeaderTopPadding = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (StatsReportViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [StatsReportViewModel new];
    }
    return _viewModel;
}

@end
