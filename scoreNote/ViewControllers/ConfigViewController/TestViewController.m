//
//  TestViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/26.
//

#import "TestViewController.h"
#import "TestCell.h"
#import "ConfigHeaderView.h"

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <ConfigHeaderModel *> *headerList;

@end

@implementation TestViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _headerList = [ConfigManager getConfigHeaderModels];
    [self.tableView reloadData];
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConfigHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kConfigHeaderId];
    
    if (section < _headerList.count) {
        ConfigHeaderModel *model = _headerList[section];
        header.model = model;
    }
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _headerList.count) {
        ConfigHeaderModel *headerModel = _headerList[section];
        
        return headerModel.configList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigCellId forIndexPath:indexPath];
    
    if (indexPath.section < _headerList.count) {
        ConfigHeaderModel *headerModel = _headerList[indexPath.section];
        
        if (indexPath.row < headerModel.configList.count) {
            ConfigModel *model = headerModel.configList[indexPath.row];
            cell.model = model;
        }
    }
    
    return cell;
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
        _tableView.rowHeight = kConfigCellH;
        _tableView.sectionHeaderHeight = kConfigHeaderH;
        [_tableView registerClass:ConfigHeaderView.class forHeaderFooterViewReuseIdentifier:kConfigHeaderId];
        [_tableView registerClass:TestCell.class forCellReuseIdentifier:kConfigCellId];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

