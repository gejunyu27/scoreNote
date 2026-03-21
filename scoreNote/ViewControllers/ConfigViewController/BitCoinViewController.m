//
//  BitCoinViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/6/8.
//

#import "BitCoinViewController.h"

#define KEY_BITCOIN @"KEY_BITCOIN"

@interface BitCoinViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) NSMutableArray <NSString *>*list;
@end

@implementation BitCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比特币账本";
    
    _list = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:KEY_BITCOIN]];
    
    [self reload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:(_list?:@[]) forKey:KEY_BITCOIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reload
{
    [self.tableView reloadData];
    
    CGFloat all = 0;
    for (NSString *text in _list) {
        all += text.floatValue;
    }
    
    _resultLabel.text = [NSString stringWithFormat:@"总计：  %@",[SCUtilities removeFloatSuffix:all]];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = indexPath.row;
    
    if (row < _list.count) {
        NSString *text = _list[row];
        cell.textLabel.text = [NSString stringWithFormat:@"%li.   %@", indexPath.row+1, text];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row < _list.count) {
        NSString *text = _list[row];
        
        [NumberInputView showWithText:text title:nil clickView:nil type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
            if (outputText.length > 0) {
                [self.list replaceObjectAtIndex:row withObject:outputText];
                [self reload];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete){
        return;
    }
    
    NSInteger row = indexPath.row;

    if (row >= _list.count) {
        return;
    }
    
    [SCUtilities alertWithTitle:@"确认删除？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        [self.list removeObjectAtIndex:row];
        [self reload];
        
    }];
    
    

}

#pragma mark -action
- (void)addClicked
{
    [NumberInputView showWithText:nil title:nil clickView:nil type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
        if (outputText.length > 0) {
            [self.list insertObject:outputText atIndex:0];
            [self reload];
        }
    }];
}

- (void)clearClicked
{
    [SCUtilities alertWithTitle:@"确定清除所有数据吗？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        [self.list removeAllObjects];
        [self reload];
    }];
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.tableHeaderView = self.topView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_FIX(50))];
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(15), 0, SCREEN_FIX(150), SCREEN_FIX(30))];
        _resultLabel.centerY = _topView.height/2;
        _resultLabel.font = SCFONT_SIZED(20);
        [_topView addSubview:_resultLabel];
        
        for (int i=0; i<2; i++) {
            CGFloat w = SCREEN_FIX(70);
            CGFloat h = SCREEN_FIX(40);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_topView.width-SCREEN_FIX(5)-w-(SCREEN_FIX(5)+w)*i, (_topView.height-h)/2, w, h)];
            btn.titleLabel.font = SCFONT_SIZED(19);
            [btn setTitleColor:[UIColor linkColor] forState:UIControlStateNormal];
            if (i==0) {
                [btn setTitle:@"新增" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [btn setTitle:@"清空" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clearClicked) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_topView addSubview:btn];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _topView.width, 1)];
        line.bottom = _topView.height;
        line.backgroundColor = [UIColor blackColor];
        [_topView addSubview:line];
    }
    return _topView;
}

@end

