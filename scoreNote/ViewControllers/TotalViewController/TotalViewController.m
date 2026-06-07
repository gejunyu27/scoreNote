//
//  TotalViewController.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/31.
//

#import "TotalViewController.h"
#import "TotalViewModel.h"
#import "TotalHeaderView.h"
#import "RecordDetailViewController.h"
#import "TagRankViewController.h"
#import "CareerViewController.h"
#import "TotalCell.h"
#import "FinanceView.h"

@interface TotalViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TotalViewModel *viewModel;



@end

@implementation TotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"统计";
    
    [self tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.viewModel.needUpdate) { //因为订单变动频繁，所以不每次接收通知都更新数据，只在打开此页面时更新一次
        [self.viewModel update];
        [self refreshUI];
        self.viewModel.needUpdate = NO;
    }
}

- (void)refreshUI
{
    self.financeView.models = self.viewModel.financeModels;
    
    //记录
    [self.tableView reloadData];
    
}

#pragma mark -action
- (void)tagRankClicked:(UIButton *)sender
{
    if (!self.viewModel.startRecord) {
        [self showWithStatus:@"还未起投"];
        return;
    }
    [self.navigationController pushViewController:[TagRankViewController new] animated:YES];
}

- (void)careerClicked:(UIButton *)sender
{
    if (!self.viewModel.startRecord) {
        [self showWithStatus:@"还未起投"];
        return;
    }
    
    CareerViewController *vc = [CareerViewController new];
    [vc setSectionList:self.viewModel.sectionList startRecord:self.viewModel.startRecord];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.sectionList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TotalHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTotalHeaderId ];
    
    if (section < self.viewModel.sectionList.count) {
        TotalSectionModel *model = self.viewModel.sectionList[section];
        header.model = model;
        
        @weakify(self)
        header.clickBlock = ^{
            @strongify(self)
            model.isOn^=1;
            [self.tableView reloadData];
        };
        
    }
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.viewModel.sectionList.count) {
        TotalSectionModel *model = self.viewModel.sectionList[section];
        return model.isOn ? model.recordList.count : 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalCell *cell = [tableView dequeueReusableCellWithIdentifier:kTotalCellId forIndexPath:indexPath];

    if (indexPath.section < self.viewModel.sectionList.count) {
        TotalSectionModel *sectionModel = self.viewModel.sectionList[indexPath.section];
        
        if (indexPath.row < sectionModel.recordList.count) {
            RecordModel *record = sectionModel.recordList[indexPath.row];
            
            cell.record = record;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section < self.viewModel.sectionList.count) {
        TotalSectionModel *sectionModel = self.viewModel.sectionList[indexPath.section];
        
        if (indexPath.row < sectionModel.recordList.count) {
            RecordModel *record = sectionModel.recordList[indexPath.row];
            RecordDetailViewController *vc = [RecordDetailViewController new];
            [vc setRecord:record canEdit:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (TotalViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [TotalViewModel new];
    }
    return _viewModel;
}

#pragma mark -UI
- (UITableView *)tableView
{
    if (!_tableView) {
        //新版
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT;
        if (@available(iOS 26.0, *)) {
            //ios26不减导航栏高度，否则会出错，原因未知 tabbar高度可减可不减。减了底部正好在tabbar上方，不减和毛玻璃效果适配'
            //            h = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
            h = SCREEN_HEIGHT; //这里不减，视觉效果最好
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = DEFAULT_BG_COLOR;
        [_tableView registerClass:TotalCell.class forCellReuseIdentifier:kTotalCellId];
        [_tableView registerClass:TotalHeaderView.class forHeaderFooterViewReuseIdentifier:kTotalHeaderId];
        _tableView.rowHeight = kTotalCellH;
        _tableView.sectionHeaderHeight = kTotalHeaderH;
        _tableView.sectionHeaderTopPadding = 0;
        
        [self.view addSubview:_tableView];
        
        //topview
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        CGFloat edge = 15;
        _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(edge, 0, topView.width-edge*2, topView.height-5)];
        [_financeView addFunctionButtonWithImage:@"TagRank" target:self action:@selector(tagRankClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_financeView addFunctionButtonWithImage:@"Carrer" target:self action:@selector(careerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:_financeView];
        _tableView.tableHeaderView = topView;
    }
    return _tableView;
}

@end
