//
//  BitCoinViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/6/8.
//

#import "BitCoinViewController.h"
#import "BitCoinModel.h"
#import "BitCoinCell.h"
#import "FinanceView.h"
#import "BitCoinViewModel.h"

@interface BitCoinViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FinanceView *financeView;
@property (nonatomic, strong) BitCoinViewModel *viewModel;
@end

@implementation BitCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比特币账本";

    [self reload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //归档
    [self.viewModel archiveData];
}

- (void)reload
{
    [self.tableView reloadData];
    
    self.financeView.models = self.viewModel.financeList;
}


#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BitCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:kBCCellId forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    
    if (row < self.viewModel.dataList.count) {
        BitCoinModel *model = self.viewModel.dataList[row];
        [cell setModel:model index:row+1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row < self.viewModel.dataList.count) {
        BitCoinModel *model = self.viewModel.dataList[row];
        NSString *text = model.money;
        
        [NumberInputView showWithText:text title:nil clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
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

    if (row >= self.viewModel.dataList.count) {
        return;
    }
    
    [SCUtilities alertWithTitle:@"确认删除？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        [self.viewModel.dataList removeObjectAtIndex:row];
        [self reload];
        
    }];
    
    

}

#pragma mark -action
- (void)transactionClicked:(BOOL)isRecharge
{
    NSString *title = isRecharge ? @"请输入存储金额" : @"请输入提现金额";
    
    [NumberInputView showWithText:nil title:title clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        if (outputText.length > 0) {
            BitCoinModel *model = [BitCoinModel new];
            model.isRecharge = isRecharge;
            model.money      = outputText;
            model.date       = [NSDate date];
            [self.viewModel.dataList insertObject:model atIndex:0];
            [self reload];
        }
    }];
}

- (void)clearClicked
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确认要清除数据？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"清除并将数据迁移至统计页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL success = [self.viewModel migrationData];//迁移数据
        [self showWithStatus:(success?@"迁移成功":@"迁移失败")];
        [self reload];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"直接清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel.dataList removeAllObjects];
        [self reload];
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];

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
        _tableView.rowHeight = kBCCellH;
        [_tableView registerClass:BitCoinCell.class forCellReuseIdentifier:kBCCellId];
        [self.view addSubview:_tableView];
        
        //topview
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
        _tableView.tableHeaderView = topView;
        
        CGFloat edge = 15;
        _financeView = [[FinanceView alloc] initWithFrame:CGRectMake(edge, 0, topView.width-edge*2, topView.height-5)];
        
        @weakify(self)
        [_financeView addFunctionButtonWithImage:@"AddIcon" eventHandler:^(id  _Nonnull sender) {
            @strongify(self)
            [self transactionClicked:YES];
        }];
        [_financeView addFunctionButtonWithImage:@"ReduceIcon" eventHandler:^(id  _Nonnull sender) {
            @strongify(self)
            [self transactionClicked:NO];
        }];
        
        [_financeView addFunctionButtonWithImage:@"ClearIcon" target:self action:@selector(clearClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        [topView addSubview:_financeView];

        

    }
    return _tableView;
}

- (BitCoinViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [BitCoinViewModel new];
    }
    return _viewModel;
}

@end

