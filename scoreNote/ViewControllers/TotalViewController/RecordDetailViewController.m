//
//  RecordDetailViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/2/5.
//

#import "RecordDetailViewController.h"

@interface RecordDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKeyboardNotification];
}

- (void)setModel:(RecordModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    [self.tableView reloadData];
    
    self.title = VALID_STRING(model.tagModel.name) ? model.tagModel.name : @"详情";
 
    //总投入
    NSString *allOut = [SCUtilities removeFloatSuffix:model.allOut];
    //总计利润
    NSString *profit = [SCUtilities removeFloatSuffix:model.allProfit];
    
    
    NSString *text = [NSString stringWithFormat:@"  净利润：%@     总投入：%@     实际%li期", profit, allOut, model.realNum];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    
    [att addAttributes:@{NSForegroundColorAttributeName:(model.allProfit>0?[UIColor redColor]:[UIColor blackColor])} range:[text rangeOfString:profit]];
    
    self.bottomLabel.attributedText = att;
    
    //备注
    if (model.note.length > 0) { //调整下坐标
        self.noteLabel.text = [NSString stringWithFormat:@"  %@",model.note];
        CGFloat noteH = 25;
        self.noteLabel.height = noteH;
        self.noteLabel.top -= noteH;
        self.bottomLabel.bottom = self.noteLabel.top;
        self.tableView.height = self.bottomLabel.top;
    }
    
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
        CGFloat h = 30;
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.noteLabel.top-h, SCREEN_WIDTH, h)];
        [self.view addSubview:_bottomLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomLabel.width, 1)];
        line.backgroundColor = [UIColor blackColor];
        [_bottomLabel addSubview:line];
    }
    return _bottomLabel;
}

- (UILabel *)noteLabel
{
    if (!_noteLabel) {
        CGFloat edge = 10;
        
        CGFloat y = SCREEN_HEIGHT-NAV_BAR_HEIGHT-SCREEN_SAFE_BOTTOM;
        if (@available(iOS 26.0, *)) {
            y = SCREEN_HEIGHT-SCREEN_SAFE_BOTTOM;
        }
        _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, y, SCREEN_WIDTH-edge*2, 0)];
        _noteLabel.layer.borderWidth = 0.5;
        _noteLabel.layer.cornerRadius = 5;
        _noteLabel.layer.borderColor = [UIColor grayColor].CGColor;
        _noteLabel.font = [UIFont systemFontOfSize:12];
        _noteLabel.text = @"无备注";
        [self.view addSubview:_noteLabel];
    }
    return _noteLabel;
}

@end

