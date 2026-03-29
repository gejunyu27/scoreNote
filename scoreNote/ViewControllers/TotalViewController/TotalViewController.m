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

@interface TotalViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *totalLabel;
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
    //总利润 //历史黑-738997.96
    NSString *totalText = [NSString stringWithFormat:@"总计：%@     共%li单",[SCUtilities removeFloatSuffix:self.viewModel.totalProfit], self.viewModel.allRecordsNum];
    self.totalLabel.text = totalText;
    
    //起投时间 (2023年9月)
    if (!self.viewModel.startRecord) {
        self.startDateLabel.text = @"还未起投";
    }else {
        self.startDateLabel.text = [NSString stringWithFormat:@"%@起投   时长%@   月均：%@", self.viewModel.startDateString, self.viewModel.periodString, [SCUtilities removeFloatSuffix:self.viewModel.perMonthProfit]];
    }
    
    //记录
    [self.tableView reloadData];
    
}

#pragma mark -action
- (void)switchChange:(UISwitch *)sender
{
    self.viewModel.isOn = sender.isOn;
    [self.tableView reloadData];
    
}

- (void)tagRankClicked:(UIButton *)sender
{
    if (!self.viewModel.startRecord) {
        [self showWithStatus:@"还未起投"];
        return;
    }
    [self.navigationController pushViewController:[TagRankViewController new] animated:YES];
}

- (void)CareerClicked:(UIButton *)sender
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
- (UIView *)topView
{
    if (!_topView) {
        CGFloat y = 0;
        //        if (@available(iOS 26.0, *)) { //老版放顶部，新版不用了
        //            /**
        //             ios适配这里有个奇怪地方
        //             NAV_BAR_HEIGHT 是98
        //             self.navigationController.navigationBar.height是54
        //             self.navigationController.navigationBar.bottom是116
        //             STATUS_BAR_HEIGHT是54
        //                如果一个页面只有tableview可以y写0，固定的写0就被盖在导航栏下。但这里导航栏高度不知道是怎么算的，先用116
        //             */
        //            y = self.navigationController.navigationBar.bottom;
        //        }
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 80)];
        //        [self.view addSubview:_topView]; //新版改为tableview的headerview
        
        //topview ui
        //背景框
        CGFloat margin = 15;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, _topView.width-margin*2, _topView.height-5)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 10;
        [bgView setCommonShadow];
        [_topView addSubview:bgView];
        
        //标签排行
        CGFloat btnH = 20;
        CGFloat btnW = 50;
        CGFloat btnY = 10;
        UIFont *btnFont = SCFONT_SIZED(12);
        UIButton *tagRankButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tagRankButton.frame = CGRectMake(bgView.width-btnW-5, btnY, btnW, btnH);
        tagRankButton.titleLabel.font = btnFont;
        [tagRankButton setTitle:@"标签排行" forState:UIControlStateNormal];
        [tagRankButton addTarget:self action:@selector(tagRankClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:tagRankButton];
        
        //生涯统计
        UIButton *careerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        careerButton.frame = CGRectMake(tagRankButton.left-btnW-5, btnY, btnW, btnH);
        careerButton.titleLabel.font = btnFont;
        [careerButton setTitle:@"生涯统计" forState:UIControlStateNormal];
        [careerButton addTarget:self action:@selector(CareerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:careerButton];
        
        //总计
        CGFloat labelX = 15;
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, btnY, careerButton.left - 15 - labelX, btnH)];
        _totalLabel.font = SCFONT_SIZED(18);
        [bgView addSubview:_totalLabel];
        
        //切换
        UISwitch *onSwitch = [UISwitch new];
        onSwitch.right = bgView.width - 10;
        onSwitch.centerY = tagRankButton.bottom + 25;
        [onSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [bgView addSubview:onSwitch];
        
        //起投
        _startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, _totalLabel.bottom+20, onSwitch.left-15-labelX, SCREEN_FIX(12))];
        _startDateLabel.width = onSwitch.left - 15 - _startDateLabel.left;
        _startDateLabel.font = SCFONT_SIZED(11);
        [bgView addSubview:_startDateLabel];
        
    }
    return _topView;
}

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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.topView;
        _tableView.backgroundColor = DEFAULT_BG_COLOR;
        [_tableView registerClass:TotalCell.class forCellReuseIdentifier:kTotalCellId];
        [_tableView registerClass:TotalHeaderView.class forHeaderFooterViewReuseIdentifier:kTotalHeaderId];
        _tableView.rowHeight = kTotalCellH;
        _tableView.sectionHeaderHeight = kTotalHeaderH;
        _tableView.sectionHeaderTopPadding = 0;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
