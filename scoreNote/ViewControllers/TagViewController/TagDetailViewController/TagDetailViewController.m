//
//  TagDetailViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/23.
//

#import "TagDetailViewController.h"
#import "TagDetailCell.h"
#import "RecordDetailViewController.h"

@interface TagDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <RecordModel *> *recordList;
@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation TagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setDataWithTagId:(NSInteger)tagId name:(nullable NSString *)name records:(nullable NSArray<RecordModel *> *)records
{
    self.title = name;
    
    if (records.count > 0) {
        _recordList = records;
        
    }else {
        //根据tagId搜索记录
        _recordList = [DataManager queryRecordsWithTagId:tagId];
    }
    
    //刷新列表
    [self.tableView reloadData];
    
    //算出总利润
    CGFloat allProfit = 0;
    for (RecordModel *record in _recordList) {
        allProfit += record.allProfit;
    }
    
    NSString *profitStr = [SCUtilities removeFloatSuffix:allProfit];
    NSString *footerStr = [NSString stringWithFormat:@"    总利润：%@         共%li单", profitStr, _recordList.count];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:footerStr];
    
    [att addAttributes:@{NSForegroundColorAttributeName:(allProfit>0?[UIColor redColor]:[UIColor blackColor])} range:[footerStr rangeOfString:profitStr]];
    
    self.footerLabel.attributedText = att;
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTDCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagDetailCell];
    
    NSInteger row = indexPath.row;
    if (row < _recordList.count) {
        RecordModel *model = _recordList[row];
        [cell setData:model row:row];
    }
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _recordList.count) {
        RecordModel *model = _recordList[indexPath.row];
        RecordDetailViewController *vc = [RecordDetailViewController new];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.footerLabel.top)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerNib:[UINib nibWithNibName:kTagDetailCell bundle:nil] forCellReuseIdentifier:kTagDetailCell];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UILabel *)footerLabel
{
    if (!_footerLabel) {
        CGFloat h = SCREEN_FIX(35);
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAV_BAR_HEIGHT-SCREEN_SAFE_BOTTOM-h, SCREEN_WIDTH, h)];
        _footerLabel.font = SCFONT_SIZED(20);
        _footerLabel.layer.borderWidth = 1;
        [self.view addSubview:_footerLabel];
    }
    return _footerLabel;
}

@end
