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
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *numLabel;

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
//    NSString *footerStr = [NSString stringWithFormat:@"    总利润：%@         共%li单", profitStr, _recordList.count];
    NSString *profitText = [NSString stringWithFormat:@"总利润：%@", profitStr];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:profitText];
    
    [att addAttributes:@{NSForegroundColorAttributeName:(allProfit>0?[UIColor redColor]:[UIColor blackColor])} range:[profitText rangeOfString:profitStr]];
    
    self.profitLabel.attributedText = att;
    
    self.numLabel.text = [NSString stringWithFormat:@"共%li单", _recordList.count];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kTDCellId];
    
    NSInteger row = indexPath.row;
    if (row < _recordList.count) {
        RecordModel *record = _recordList[row];
        [cell setRecord:record row:row];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _recordList.count) {
        RecordModel *record = _recordList[indexPath.row];
        RecordDetailViewController *vc = [RecordDetailViewController new];
        [vc setRecord:record canEdit:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.topView;
        _tableView.backgroundColor = DEFAULT_BG_COLOR;
        _tableView.rowHeight = kTDCellH;
        [_tableView registerClass:TagDetailCell.class forCellReuseIdentifier:kTDCellId];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)topView
{
   if (!_topView) {

       _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
       
       //topview ui
       //背景框
       CGFloat margin = 15;
       UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, _topView.width-margin*2, _topView.height-5)];
       bgView.backgroundColor = [UIColor whiteColor];
       bgView.layer.cornerRadius = 10;
       [bgView setCommonShadow];
       [_topView addSubview:bgView];
       
       //利润
       _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 200, bgView.height)];
       _profitLabel.font = SCFONT_SIZED(20);
       [bgView addSubview:_profitLabel];
       
       //单子数
       CGFloat w = 80;
       _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.width-margin-w, 0, w, bgView.height)];
       _numLabel.font = _profitLabel.font;
       _numLabel.textAlignment = NSTextAlignmentRight;
       [bgView addSubview:_numLabel];
       
   }
   return _topView;
}
@end
