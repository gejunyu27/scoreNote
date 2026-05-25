//
//  BitCoinViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/6/8.
//

#import "BitCoinViewController.h"
#import "BitCoinModel.h"
#import "BitCoinCell.h"

@interface BitCoinViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) NSMutableArray <BitCoinModel *>*models;
@end

@implementation BitCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比特币账本";
    
    [self initData];
    
    [self reload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //归档
    [self saveData];
}

- (void)reload
{
    [self.tableView reloadData];
    
    CGFloat all = 0;
    for (BitCoinModel *model in _models) {
        all += model.money.floatValue;
    }
    
    _resultLabel.text = [NSString stringWithFormat:@"总计：  %@",[SCUtilities removeFloatSuffix:all]];
}

#pragma mark -data
- (void)initData
{
    _models = [NSMutableArray array];
    
    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
    if (!data) {
        return;
    }
    
    NSError *error = nil;
    
    NSArray *readArr = [NSKeyedUnarchiver  unarchivedObjectOfClasses:[NSSet setWithArray:@[NSArray.class, BitCoinModel.class, NSDate.class]] fromData:data error:&error];
    
    if (!error && readArr.count > 0) {
        _models = readArr.mutableCopy;
    }
    
}

- (void)saveData
{

    NSError *error = nil;
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:_models requiringSecureCoding:NO error:&error];
    
    if (!error) {
        [archiveData writeToFile:[self filePath] atomically:YES];
    }
}

- (NSString *)filePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"BitCoinArray.archive"];
    
    return filePath;
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BitCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:kBCCellId forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    
    if (row < _models.count) {
        BitCoinModel *model = _models[row];
        [cell setModel:model row:row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row < _models.count) {
        BitCoinModel *model = _models[row];
        NSString *text = model.money;
        
        [NumberInputView showWithText:text title:nil clickView:nil type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
            if (outputText.length > 0) {
                model.money = outputText;
                [self reload];
            }
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete){
        return;
    }
    
    NSInteger row = indexPath.row;

    if (row >= _models.count) {
        return;
    }
    
    [SCUtilities alertWithTitle:@"确认删除？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        [self.models removeObjectAtIndex:row];
        [self reload];
        
    }];
    
    

}

#pragma mark -action
- (void)addClicked
{
    [NumberInputView showWithText:nil title:nil clickView:nil type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
        if (outputText.length > 0) {
            BitCoinModel *model = [BitCoinModel new];
            model.money = outputText;
            model.date = [NSDate date];
            [self.models insertObject:model atIndex:0];
            [self reload];
        }
    }];
}

- (void)clearClicked
{
    [SCUtilities alertWithTitle:@"确定清除所有数据吗？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        [self.models removeAllObjects];
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
        _tableView.sectionHeaderTopPadding = 0;
        _tableView.tableHeaderView = self.topView;
        _tableView.rowHeight = kBCCellH;
        [_tableView registerClass:BitCoinCell.class forCellReuseIdentifier:kBCCellId];
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

