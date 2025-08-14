//
//  RecordDetailViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/2/5.
//

#import "RecordDetailViewController.h"

@interface RecordDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setModel:(RecordModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    [self.tableView reloadData];
    
    self.title = VALID_STRING(model.tagModel.name) ? model.tagModel.name : @"详情";
 
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //创建时间
    NSString *startTime = [model.startTime getStringWithDateFormat:dateFormat];
    //结束时间
    NSString *endTime = [model.endTime getStringWithDateFormat:dateFormat]?:@"（进行中）";
    //总计利润
    NSString *profit = [SCUtilities removeFloatSuffix:model.allProfit];
    
    NSString *text = [NSString stringWithFormat:@"  实际期数：%li期 \n  开始时间：%@ \n  结束时间：%@ \n  总计利润：%@\n  备注内容：%@", model.realNum, startTime, endTime, profit, model.note];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    
    [att addAttributes:@{NSForegroundColorAttributeName:(model.allProfit>0?[UIColor redColor]:[UIColor blackColor])} range:[text rangeOfString:profit]];
    
    self.bottomLabel.attributedText = att;
    
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.lineList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = SCFONT_SIZED(11);
    }
    
    NSInteger row = indexPath.row;
    if (row < _model.lineList.count) {
        LineModel *line = _model.lineList[row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li.    %@         %@", row+1, [SCUtilities removeFloatSuffix:line.outMoney], [SCUtilities removeFloatSuffix:line.getMoney]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",(VALID_STRING(line.overScore)?line.overScore:@""), [line.beginTime getStringWithDateFormat:@"yyyy-MM-dd"]];
        
        
        
    }
    
    return cell;
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bottomLabel.top)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        CGFloat h = 140;
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAV_BAR_HEIGHT-SCREEN_SAFE_BOTTOM-h, SCREEN_WIDTH, h)];
        _bottomLabel.numberOfLines = 5;
        _bottomLabel.layer.borderWidth = 1;
        [self.view addSubview:_bottomLabel];
    }
    return _bottomLabel;
}

@end

