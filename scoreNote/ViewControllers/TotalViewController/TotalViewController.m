//
//  TotalViewController.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/31.
//

#import "TotalViewController.h"
#import "TotalViewModel.h"
#import "CommonHeaderView.h"
#import "RecordDetailViewController.h"
#import "TagRankViewController.h"
#import "CareerViewController.h"

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
    if (self.viewModel.needUpdate) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCommonHeaderH;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headId = @"headId";
    
    CommonHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    
    if (!view) {
        view = [[CommonHeaderView alloc] initWithReuseIdentifier:headId];
    }
    
    if (section < self.viewModel.sectionList.count) {
        TotalSectionModel *model = self.viewModel.sectionList[section];
        [view setTotalSection:model];
        @weakify(self)
        view.clickBlock = ^{
            @strongify(self)
            model.isOn^=1;
            [self.tableView reloadData];
        };
    }
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = SCFONT_SIZED(24);
        cell.detailTextLabel.font = SCFONT_SIZED(10);
    }
    
    if (indexPath.section < self.viewModel.sectionList.count) {
        TotalSectionModel *sectionModel = self.viewModel.sectionList[indexPath.section];
        
        if (indexPath.row < sectionModel.recordList.count) {
            RecordModel *record = sectionModel.recordList[indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[SCUtilities removeFloatSuffix:record.allProfit]];
            cell.textLabel.textColor = record.allProfit > 0 ? [UIColor redColor] : [UIColor blackColor];
            
            NSString *tagName = record.overTagName.length > 0 ? record.overTagName : record.tagModel.name;
            tagName = tagName.length > 0 ? tagName : @"无";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %li期", tagName, record.realNum];
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
            vc.model = record;
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
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_FIX(70))];
        _topView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_topView]; //新版改为tableview的headerview
        
        //topview ui
        //标签排行
        CGFloat btnH = SCREEN_FIX(20);
        CGFloat btnW = SCREEN_FIX(50);
        CGFloat btnY = SCREEN_FIX(5);
        UIFont *btnFont = SCFONT_SIZED(12);
        UIButton *tagRankButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tagRankButton.frame = CGRectMake(_topView.width-btnW-5, btnY, btnW, btnH);
        tagRankButton.titleLabel.font = btnFont;
        [tagRankButton setTitle:@"标签排行" forState:UIControlStateNormal];
        [tagRankButton addTarget:self action:@selector(tagRankClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:tagRankButton];
        
        //生涯统计
        UIButton *careerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        careerButton.frame = CGRectMake(tagRankButton.left-btnW-5, btnY, btnW, btnH);
        careerButton.titleLabel.font = btnFont;
        [careerButton setTitle:@"生涯统计" forState:UIControlStateNormal];
        [careerButton addTarget:self action:@selector(CareerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:careerButton];
        
        //总计
        CGFloat labelX = 15;
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, btnY, careerButton.left - 15 - labelX, btnH)];
        _totalLabel.font = SCFONT_SIZED(18);
        [_topView addSubview:_totalLabel];
        
        //切换
        UISwitch *onSwitch = [UISwitch new];
        onSwitch.right = _topView.width - SCREEN_FIX(10);
        onSwitch.centerY = tagRankButton.bottom + SCREEN_FIX(25);
        [onSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [_topView addSubview:onSwitch];
        
        //起投
        _startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, _totalLabel.bottom+SCREEN_FIX(20), onSwitch.left-15-labelX, SCREEN_FIX(12))];
        _startDateLabel.width = onSwitch.left - 15 - _startDateLabel.left;
        _startDateLabel.font = SCFONT_SIZED(11);
        [_topView addSubview:_startDateLabel];
        
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        //老版代码
//        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT - self.topView.bottom;
//        if (@available(iOS 26.0, *)) {
//            //ios26不减导航栏高度，否则会出错，原因未知 tabbar高度可减可不减。减了底部正好在tabbar上方，不减和毛玻璃效果适配'
//            //            h = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
//            h = SCREEN_HEIGHT - self.topView.bottom; //这里不减，视觉效果最好
//        }
        
        //新版
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT;
        if (@available(iOS 26.0, *)) {
            //ios26不减导航栏高度，否则会出错，原因未知 tabbar高度可减可不减。减了底部正好在tabbar上方，不减和毛玻璃效果适配'
            //            h = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
            h = SCREEN_HEIGHT; //这里不减，视觉效果最好
        }
        
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0/*self.topView.bottom*/, SCREEN_WIDTH, h)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.topView;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
