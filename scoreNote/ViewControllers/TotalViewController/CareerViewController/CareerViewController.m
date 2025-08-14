//
//  CareerViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/1.
//

#import "CareerViewController.h"
#import "CareerViewModel.h"
#import "CareerCell.h"
#import "RecordDetailViewController.h"

#define kCareerCell @"CareerCell"

@interface CareerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CareerViewModel *viewModel;

@end

@implementation CareerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生涯统计";
}

- (void)setSectionList:(NSMutableArray<TotalSectionModel *> *)sectionList startRecord:(nullable RecordModel *)startRecord
{
    [self.viewModel setSectionList:sectionList startRecord:startRecord];
    
    [self.tableView reloadData];
}



#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.careerList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CareerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCareerCell];
    
    NSInteger row = indexPath.row;
    NSArray *datas = self.viewModel.careerList;
    if (row < datas.count) {
        CareerModel *model = datas[row];
        [cell setData:model row:row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSInteger row = indexPath.row;
    NSArray *datas = self.viewModel.careerList;
    
    if (row < datas.count) {
        CareerModel *model = datas[row];
        
        if (model.record) {
            RecordDetailViewController *vc = [RecordDetailViewController new];
            vc.model = model.record;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerNib:[UINib nibWithNibName:kCareerCell bundle:nil] forCellReuseIdentifier:kCareerCell];

        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CareerViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [CareerViewModel new];
    }
    return _viewModel;
}

@end
