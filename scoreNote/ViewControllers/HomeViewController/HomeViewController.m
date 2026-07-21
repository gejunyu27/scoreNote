//
//  HomeViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "RecordManager.h"
#import "TagSelectView.h"
#import "RecordDetailViewController.h"
#import <WebKit/WebKit.h>
#import "NetworkReachability.h"

#define KEY_WEB_DATE @"KEY_WEB_DATE"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, HomeCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) NSMutableArray <RecordModel *> *records;
@property (nonatomic, assign) BOOL isWebMode; //是否是嵌入网页模式
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ui 嵌套网页 和 添加单子
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddItem"] style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebItem"] style:UIBarButtonItemStylePlain target:self action:@selector(webClick)];

    //刷新数据
    [self refreshUI];
    
    [RecordManager updateBlock:^{
        [self refreshUI];
    }];

}

- (void)refreshUI
{
    //获取首页展示记录
    _records = [RecordManager homeRecords];
    
    [self.tableView reloadData];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeCellId forIndexPath:indexPath];
    cell.delegate = self;
    
    if (indexPath.row < _records.count) {
        RecordModel *record = _records[indexPath.row];
        cell.record = record;
    }
    
    
    return cell;
}

#pragma mark -HomeCellDelegate
- (void)homeCellTagSelect:(RecordModel *)record
{
    [TagSelectView show:^(TagModel * _Nullable tag) {
        BOOL result = [RecordManager editTag:(tag ? tag.tagId : 0) record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellEditRealNum:(RecordModel *)record
{
    @weakify(self)
    NSString *text = record.realNum ? [NSString stringWithFormat:@"%li", record.realNum] : @"";
    [NumberInputView showWithText:text title:@"编辑实际期数" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        NSInteger realNum = MAX(outputText.integerValue, 0);
        BOOL result = [RecordManager editRealNum:realNum record:record];
        [self refreshTableViewWithResult:result];
        
    }];
    
}

- (void)homeCellEditScore:(RecordModel *)record
{
    @weakify(self)
    [NumberInputView showWithText:record.currentScore title:@"编辑买法" clickView:nil type:InputTypeDefault block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        BOOL result = [RecordManager editCurrentScore:outputText record:record];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellBuy:(RecordModel *)record
{
    [NumberInputView showWithText:nil title:@"输入投入额" clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        CGFloat outmoney = VALID_STRING(outputText) ? outputText.floatValue : 0;
        if (outmoney <= 0) {
            return;
        }
        
        BOOL result = [RecordManager addNewLine:record outMoney:outmoney];
        [self refreshTableViewWithResult:result];
    }];
}

- (void)homeCellShowDetails:(RecordModel *)record
{
    RecordDetailViewController *vc = [RecordDetailViewController new];
    [vc setRecord:record canEdit:YES];
    @weakify(self)
    vc.updateBlock = ^{
      @strongify(self)
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeCellOverRecord:(RecordModel *)record
{
    if (!record || record.lineList.count == 0) {
        [self showWithStatus:@"无购买记录"];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"确定要结束%@吗", record.tagModel.name];
    
    [SCUtilities alertWithTitle:title message:nil textFieldBlock:nil sureBlock:^(NSString * _Nonnull text) {
        BOOL result = [RecordManager closeRecord:record];
        [self refreshTableViewWithResult:result];
    }];
  
}

- (void)homeCellBuyLose:(RecordModel *)record
{
    BOOL result = [RecordManager lastLineLose:record];
    [self refreshTableViewWithResult:result];
    
}

- (void)homeCellBuyWin:(RecordModel *)record
{
    @weakify(self)
    [NumberInputView showWithText:@"" title:(record.isCasino?@"利润":@"收入") clickView:nil type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        if (outputText.length == 0) {
            return;
        }
        
        CGFloat profit = outputText.floatValue;
        
        BOOL result = [RecordManager lastLineWin:profit record:record];
        
        [self refreshTableViewWithResult:result];

    }];
}

- (void)refreshTableViewWithResult:(BOOL)result
{
    if (result) {
        [self.tableView reloadData];
        
    }else {
        [self showWithStatus:@"修改失败"];
    }
}

#pragma mark -action
- (void)addClick
{
    [TagSelectView show:^(TagModel * _Nullable tag) {
        BOOL result = [RecordManager addNewRecord:tag.tagId];
        [self refreshTableViewWithResult:result];
        
    }];
}

- (void)webClick //嵌套网页模式
{
    if (_isWebMode) { //关闭网页
        _isWebMode            = NO;
        self.tableView.height = SCREEN_HEIGHT;
        self.webView.hidden   = YES;
        [NetworkReachability stopMontitorNetwork]; //停止监测
//        self.tabBarController.tabBarHidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    }else { //打开网页
        _isWebMode            = YES;
//        self.tableView.height = [ConfigManager getValue:ConfigTypeOrderListH];
//        self.webView.height   = [ConfigManager getValue:ConfigTypeOrderWebH];
//        self.webView.bottom   = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
        
        self.webView.height = [ConfigManager getValue:ConfigTypeOrderWebH];
        self.webView.bottom = SCREEN_HEIGHT - SCREEN_SAFE_BOTTOM;
        
        self.tableView.height = self.webView.top;

//        self.tabBarController.tabBarHidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        self.webView.hidden   = NO;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        //判断有没有网
        BOOL isNetworkOK = [NetworkReachability isReachable];
        
        if (!isNetworkOK) { //没网就开始监测，等用户点击使用网络
            [NetworkReachability startMonitorNetwork:^{
                [self.webView reload];
                [ud setObject:[NSDate date] forKey:KEY_WEB_DATE]; //存储加载时间
            }];
            
        }else { //检测上次什么时候打开的网页，有可能出现这种情况：昨天打开过网页，但是app一直没杀掉，今天再打开显示的还是昨天网页
            NSDate *lastDate = [ud objectForKey:KEY_WEB_DATE];
            if (![lastDate isToday]) {
                [self.webView reload];
                [ud setObject:[NSDate date] forKey:KEY_WEB_DATE];
            }
            
        }
    }
    
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
        _tableView.rowHeight = kHomeCellH;
        [_tableView registerClass:HomeCell.class forCellReuseIdentifier:kHomeCellId];
        _tableView.backgroundColor = DEFAULT_BG_COLOR;
        _tableView.sectionHeaderTopPadding = 0;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore]; //使用默认的持久化数据储存（自动存Cooki、登录状态等）
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) configuration:config];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _webView.scrollView.bounces = NO; //取消回弹
        _webView.pageZoom = 0.8; //缩放
        [self.view addSubview:_webView];
        [self.view sendSubviewToBack:_webView];
        
//        NSURL *url = [NSURL URLWithString:@"https://m.sporttery.cn/mjc/jsq/zqhhgg/"]; //混合过关
        NSURL *url = [NSURL URLWithString:@"https://m.sporttery.cn/mjc/jsq/zqspf/"]; //胜平负
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
        //存储加载时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KEY_WEB_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return _webView;
}


@end
