//
//  TagRankViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/20.
//

#import "TagRankViewController.h"
#import "RecordDetailViewController.h"
#import "TagRankCell.h"
#import "TagRankViewModel.h"
#import "TagDetailViewController.h"

@interface TagRankViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TagRankViewModel *viewModel;
@end


@implementation TagRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签排行";
    
    [self.tableView reloadData];
    
}




#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.rankList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTRCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TagRankCell.class)];
    
    NSInteger row = indexPath.row;
    if (row < self.viewModel.rankList.count) {
        TagRankModel *model = self.viewModel.rankList[row];
        
        [cell setData:model row:row];
    }
   
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < self.viewModel.rankList.count) {
        TagRankModel *model = self.viewModel.rankList[row];
        TagDetailViewController *vc = [TagDetailViewController new];
        [vc setDataWithTagId:model.tagId name:model.name records:model.recordList];
        [self.navigationController pushViewController:vc animated:YES];
        
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
        [_tableView registerClass:TagRankCell.class forCellReuseIdentifier:NSStringFromClass(TagRankCell.class)];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (TagRankViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [TagRankViewModel new];
    }
    return _viewModel;
}

@end
