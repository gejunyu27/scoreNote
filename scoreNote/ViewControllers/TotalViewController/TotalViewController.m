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
@property (weak, nonatomic) IBOutlet UIButton *totalButton;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TotalViewModel *viewModel;



@end

@implementation TotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"统计";
    
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
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
    [self.totalButton setTitle:totalText forState:UIControlStateNormal];
    
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
- (IBAction)switchAction:(UISwitch *)sender {
    self.viewModel.isOn = sender.isOn;
    [self.tableView reloadData];
}

- (IBAction)tagRankAction:(UIButton *)sender {
    if (!self.viewModel.startRecord) {
        [self showWithStatus:@"还未起投"];
        return;
    }
    [self.navigationController pushViewController:[TagRankViewController new] animated:YES];
}

- (IBAction)CareerStatusAction:(UIButton *)sender {
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

@end
