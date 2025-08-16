//
//  HomeViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "HomeViewController.h"
#import "SideBar.h"
#import "RecordView.h"
#import "RecordManager.h"
#import "TagSelectView.h"

@interface HomeViewController () <RecordViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SideBar *sideBar;
@property (nonatomic, strong) NSMutableArray <RecordView *> *viewList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新ui
    [self refreshUI];
    
    //添加键盘监控
    [self addKeyboardNotification];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([RecordManager sharedInstance].needUpdate) {
        [self refreshUI];
        [RecordManager sharedInstance].needUpdate = NO;
    }
}

- (void)refreshUI
{
    //获取首页展示的记录
    NSMutableArray <RecordModel *> *homeRecords = [RecordManager homeRecords];
    
    NSInteger maxLineNum = 10; //最大列数
    
    for (RecordModel *record in homeRecords) {
        maxLineNum = MAX(maxLineNum, record.lineList.count+1);
    }
    
    //边框
    self.sideBar.num = maxLineNum;
    
    //创建view
    [self createRecordViews:homeRecords.count];
    
    //赋值
    __block CGFloat x = self.sideBar.right;
    __block CGFloat maxH = self.scrollView.height+1;
    
    [self.viewList enumerateObjectsUsingBlock:^(RecordView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= homeRecords.count) {
            view.hidden = YES;
            return;
        }
        
        view.hidden = NO;
        view.left = x;
        
        RecordModel *record = homeRecords[idx];
        [view refreshUI:record title:[NSString stringWithFormat:@"%li",idx+1] maxNum:maxLineNum];
        
        x = view.right-1;
        
        maxH = MAX(maxH, view.bottom);
    }];
    
    //滚动范围
    self.scrollView.contentSize = CGSizeMake(MAX(_scrollView.width+1, x), maxH);
}

#pragma mark -RecordViewDelegate
- (void)recordView:(RecordView *)recordView insertNewLineWithRecord:(RecordModel *)record view:(nullable UIView *)view
{
    [NumberInputView showWithText:nil title:@"输入支出" clickView:view type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        CGFloat outmoney = VALID_STRING(outputText) ? outputText.floatValue : 0;
        if (outmoney == 0) {
            return;
        }
        
        BOOL result = [RecordManager addNewLine:record outMoney:outmoney];
        if (result) {
            [self refreshUI];
        }else {
            [self showWithStatus:@"添加失败"];
        }
    }];
    

}

- (void)recordView:(RecordView *)recordView tagSelect:(RecordModel *)record
{
    [TagSelectView show:^(TagModel * _Nullable tag) {
        BOOL result = [RecordManager editTag:(tag ? tag.tagId : 0) record:record];
        if (result) {
            [recordView refreshUI];
        }else {
            [self showWithStatus:@"修改失败"];
        }
    }];
}

- (void)recordView:(RecordView *)recordView editRealNum:(RecordModel *)record
{
    [RecordManager editRealNum:record];
}



- (void)recordView:(RecordView *)recordView editNote:(NSString *)note record:(RecordModel *)record
{
    BOOL result = [RecordManager editNote:note record:record];
    if (!result) {
        [self showWithStatus:@"修改失败"];
    }
}

- (void)recordView:(RecordView *)recordView editRecord:(RecordModel *)record
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"移除最后一列" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reduceLine:record];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"修改每期利润：%@", [SCUtilities removeFloatSuffix:record.profitPerLine]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editProfitPerLine:record];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"修改固定利润：%@", [SCUtilities removeFloatSuffix:record.baseProfit]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editBaseProfit:record];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"修改止损线：%@", [SCUtilities removeFloatSuffix:record.breakLine]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editBreakLine:record];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)reduceLine:(RecordModel *)record
{
    [SCUtilities alertWithTitle:@"确定要删除最后一列吗？" message:nil textFieldBlock:nil sureBlock:^(NSString * _Nonnull text) {
        BOOL result = [RecordManager deleteLastLine:record];
        if (result) {
            [self refreshUI];
        }else {
            [self showWithStatus:@"删除失败"];
        }
        
    }];
    
}

- (void)editProfitPerLine:(RecordModel *)record
{
    NSString *text = record.profitPerLine == 0 ? @"" :[SCUtilities removeFloatSuffix:record.profitPerLine];
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改每期利润" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editProfitPerLine:outputText.floatValue record:record];
        if (result) {
            [self refreshUI];
        }else {
            [self showWithStatus:@"修改失败"];
        }
    }];
}

- (void)editBaseProfit:(RecordModel *)record
{
    NSString *text = record.baseProfit == 0 ? @"" :[SCUtilities removeFloatSuffix:record.baseProfit];
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改固定利润" clickView:nil type:InputTypeReduce block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editBaseProfit:outputText.floatValue record:record];
        if (result) {
            [self refreshUI];
        }else {
            [self showWithStatus:@"修改失败"];
        }
    }];
    
}

- (void)editBreakLine:(RecordModel *)record
{
    NSString *text = record.breakLine == 0 ? @"" :[SCUtilities removeFloatSuffix:record.breakLine];
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"修改止损线" clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editBreakLine:outputText.floatValue record:record];
        if (result) {
            [self refreshUI];
            
        }else {
            [self showWithStatus:@"修改失败"];
        }
    }];
}

- (void)recordView:(RecordView *)recordView overRecord:(nonnull RecordModel *)record
{
    if (!record || record.lineList.count == 0) {
        [self showWithStatus:@"无购买记录"];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"确定要结束%@吗", record.tagModel.name];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"结束" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self closeRecord:record];
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}


- (void)closeRecord:(RecordModel *)record
{
    //关闭
    BOOL closeResult = [RecordManager closeRecord:record];
    if (!closeResult) {
        [self showWithStatus:@"关闭失败"];
        return;
    }
    
    //刷新页面
    [self refreshUI];
    
}

#pragma mark -ui
- (void)createRecordViews:(NSInteger)count
{
    if (!_viewList) {
        _viewList = [NSMutableArray array];
    }
    
    //先创建缺几个view 考虑以后可能会增加新增记录功能
    NSInteger num = count - _viewList.count;
    
    if (num <= 0) {
        return;
    }
    
    for (int i=0; i<num; i++) {
        RecordView *rv = [RecordView new];
        rv.delegate = self;
        [self.scrollView addSubview:rv];
        [_viewList addObject:rv];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (SideBar *)sideBar
{
    if (!_sideBar) {
        _sideBar = [[SideBar alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        [self.scrollView addSubview:_sideBar];
    }
    return _sideBar;
}

@end
