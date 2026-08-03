//
//  SportteryViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/2.
//

#import "SportteryViewController.h"

#import <WebKit/WebKit.h>
#import "NetworkReachability.h"

@interface SportteryViewController ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *indicator; //注入js后刷新组件的菊花消失，可能是因为y过高在屏幕外面，解决之前先用这个代替
@property (nonatomic, strong) UIView *calculatorView; //计算器视图
@property (nonatomic, strong) UIButton *oddsOneButton;
@property (nonatomic, strong) UIButton *oddsTwoButton;
@property (nonatomic, strong) UIButton *planButton;
@property (nonatomic, strong) UIButton *resultButton;
@property (nonatomic, strong) NSArray *urlList;

@end

@implementation SportteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //计算器
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CalculatorItem"] style:UIBarButtonItemStylePlain target:self action:@selector(calculatorClick)];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *spfUrl = self.urlList.firstObject;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:spfUrl]];
        
        //判断有没有网
        BOOL isNetworkOK = [NetworkReachability isReachable];
        
        if (!isNetworkOK) { //没网就开始监测，等用户点击使用网络
            [NetworkReachability startMonitorNetwork:^{
                [self.webView loadRequest:request];
            }];
            
        }else {
            [self.webView loadRequest:request];
        }
    }
    return self;
}

#pragma mark - WKNavigationDelegate 核心跳转拦截（监测点击按钮/链接跳转）
/**
 页面即将发起跳转（所有a标签、js跳转、按钮window.location都会进这里）
 navigationAction.request.URL = 即将要打开的页面地址
 navigationAction.navigationType 判断跳转类型：链接点击、表单提交、返回前进、页面重定向等
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    /**加入拦截。**/
    // 1. 获取即将跳转的url
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    //只允许跳转的几个页面
    if ([self.urlList containsObject:urlStr]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }else { //拦截
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

#pragma mark - webview scrollview代理
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //注入js
    [self evaluateJavaScript]; //初始化webview时就注入无效，只能放加载完成注入
    
    //停止刷新
    [self endRefresh];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    //停止刷新
    [self endRefresh];
}

- (void)evaluateJavaScript
{
    CGFloat topPaddingValue = IS_BANGS_SCREEN ? 30.f : 15.f;
    
    NSString *js = [NSString stringWithFormat:
    @"setTimeout(function(){"
    // 网页整体顶部留出空白，数值自行调整  = 空白高度px
    @"document.documentElement.style.paddingTop = '%.0fpx';"
    @"document.body.style.paddingTop = '%.0fpx';"
    // 删除全部 m-header 标题栏
    @"document.querySelectorAll('.m-header').forEach(function(item){item.remove();});"
    // 隐藏 calculator_menu 保留高度 //胜平负，混合，比分等选项 之前隐藏，现在保留
//    @"var menuDom = document.getElementById('calculator_menu');"
//    @"if(menuDom){"
//    @"    menuDom.style.visibility = 'hidden';"
//    @"}"
    //直接移除 id="sel_pan" 底部黑色tabbar
    @"var selPan = document.getElementById('sel_pan');"
    @"if(selPan) selPan.remove();"
    @"},000);"//这个0是延迟执行时间，避免失效，但目前测试不需要延迟也可以
    ,topPaddingValue,topPaddingValue];
    [_webView evaluateJavaScript:js completionHandler:nil];
}

- (void)endRefresh
{
    // 结束下拉刷新动画
    if (self.refreshControl.refreshing) {
        [self.refreshControl endRefreshing];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //起始位置是0，上滑增大，下拉减小
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //菊花位置
    CGFloat orignY = NAV_BAR_HEIGHT - 50; //初始位置
    CGFloat newY = orignY - offsetY;
    self.indicator.top = newY;
    
    //菊花透明度
    if (offsetY > -40) { //偏移量40之前不显示 否则影响美观
        _indicator.alpha = 0;
        [_indicator stopAnimating];
        
    }else {
        if (offsetY < -170) { //滑动测试了下 大约170开始执行刷新
            _indicator.alpha = 1;
            [_indicator startAnimating]; //开始转圈
            
        }else {
            _indicator.alpha = 0.2;
        }
    }

}

#pragma mark -action
//刷新
- (void)webRefreshAction
{
    // 网页重载
    [self.webView reload];
}

//计算器
- (void)calculatorClick
{
    self.calculatorView.hidden ^= 1;
    if (self.calculatorView.hidden) {
        [self clearCalculatorAction];
    }
}

//滑动手势
- (void)panScrollHandle:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat offsetX = [pan translationInView:self.webView].x;
        //横向滑动阈值 40px，超过判定为切换Tab
        CGFloat maxX = 40;
        if (offsetX > maxX) { //手指右滑，切换左边页面
            [self swichPage:YES];
            
        } else if (offsetX < -maxX) { //手指左滑，切换右边页面
            [self swichPage:NO];
        }
    }
}

- (void)swichPage:(BOOL)isLeftPage
{
    NSString *currentUrl = _webView.URL.absoluteString;
    
    NSInteger currentIndex = 0;
    
    if ([_urlList containsObject:currentUrl]) {
        currentIndex = [_urlList indexOfObject:currentUrl]; //获取当前网页下标
    }
    
    //第一个不能再左滑 最后一个不能再右滑
    if ((currentIndex == 0 && isLeftPage) || (currentIndex == _urlList.count-1 && !isLeftPage)) {
        return;
    }
    
    NSInteger newIndex = isLeftPage ? currentIndex-1 : currentIndex+1;
    
    NSString *newUrl = _urlList[newIndex];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newUrl]]];
}

- (void)calculateClicked:(UIButton *)sender title:(NSString *)title
{
    [NumberInputView showWithText:sender.currentTitle title:title clickView:sender type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        [sender setTitle:outputText forState:UIControlStateNormal];
        [self startCalculateResult];
    }];
}

- (void)startCalculateResult
{
    //检查完整性
    CGFloat oddsOne = _oddsOneButton.currentTitle.floatValue;
    CGFloat oddsTwo = _oddsTwoButton.currentTitle.floatValue;
    CGFloat plan    = _planButton.currentTitle.floatValue;
    
    if (oddsOne > 1 && oddsTwo > 1 && plan > 0) {
        CGFloat odds = oddsOne*oddsTwo; //3*4=12 标识1块钱中了能收回12
        CGFloat result = plan/(odds-1);
        [_resultButton setTitle:[SCUtilities removeFloatSuffix:result] forState:UIControlStateNormal];
        
    }else {
        [_resultButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)clearCalculatorAction
{
    [_oddsOneButton setTitle:nil forState:UIControlStateNormal];
    [_oddsTwoButton setTitle:nil forState:UIControlStateNormal];
    [_planButton setTitle:nil forState:UIControlStateNormal];
    [_resultButton setTitle:nil forState:UIControlStateNormal];
}

#pragma mark -UI
- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore]; //使用默认的持久化数据储存（自动存Cooki、登录状态等）

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
//        _webView.scrollView.bounces = NO; //取消回弹
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [self.view addSubview:_webView];
        
        //滑动手势
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScrollHandle:)];
        panGes.cancelsTouchesInView = NO;
        [_webView addGestureRecognizer:panGes];
    
        //下拉刷新
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [UIColor grayColor];
        [_refreshControl addTarget:self action:@selector(webRefreshAction) forControlEvents:UIControlEventValueChanged];
        // 挂载到webview滚动视图
        self.webView.scrollView.refreshControl = self.refreshControl;
        
    }
    return _webView;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        // 中心放在页面中间
        _indicator.center = self.view.center;
        // 菊花颜色自定义
//        _indicator.color = [UIColor orangeColor];
        // 初始停止动画（不转圈）
        _indicator.hidesWhenStopped = NO; // 停止时自动隐藏
        [self.view addSubview:_indicator];
    }
    return _indicator;
}

- (UIView *)calculatorView
{
    if (!_calculatorView) {
        CGFloat x = 20;
        CGFloat h = 65;
        _calculatorView = [[UIView alloc] initWithFrame:CGRectMake(x, SCREEN_HEIGHT-TAB_BAR_HEIGHT-10-h, SCREEN_WIDTH-x*2, h)];
        _calculatorView.hidden = YES;
        _calculatorView.backgroundColor = [UIColor blackColor];
        _calculatorView.layer.cornerRadius = 8;
        [self.view addSubview:_calculatorView];
        
        CGFloat labelW = _calculatorView.width/4;
        NSArray *labelArr = @[@"赔率1", @"赔率2", @"计划利润", @"所需投注"];
        
        for (int i=0; i<labelArr.count; i++) {
            NSString *name = labelArr[i];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelW*i, 0, labelW, 30)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = SCFONT_SIZED(14);
            label.text = name;
            [_calculatorView addSubview:label];
            
            CGFloat btnY = label.bottom;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, labelW-25, _calculatorView.height-btnY-10)];
            btn.centerX = label.centerX;
            [_calculatorView addSubview:btn];
            
            if (i==labelArr.count-1) { //结果
                btn.titleLabel.font = SCFONT_SIZED(18);
                [btn addTarget:self action:@selector(clearCalculatorAction) forControlEvents:UIControlEventTouchUpInside];
                _resultButton = btn;
                
            }else {
                btn.backgroundColor = [UIColor whiteColor];
                btn.titleLabel.font = SCFONT_SIZED(14);
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                @weakify(self)
                [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
                    @strongify(self)
                    [self calculateClicked:btn title:name];
                }];
                
                if (i==0) { //赔率1
                    _oddsOneButton = btn;
                }else if (i==1) { //赔率2
                    _oddsTwoButton = btn;
                }else if (i==2) { //计划利润
                    _planButton = btn;
                }
                 
            }
        }
        
    }
    return _calculatorView;
}

#pragma mark -lazy load
- (NSArray *)urlList
{
    if (!_urlList) {
        _urlList = @[@"https://m.sporttery.cn/mjc/jsq/zqspf/",    //胜平负
                     @"https://m.sporttery.cn/mjc/jsq/zqbf/",     //比分
                     @"https://m.sporttery.cn/mjc/jsq/zqzjq/",    //总进球
                     @"https://m.sporttery.cn/mjc/jsq/zqbqc/",    //半全场
                     @"https://m.sporttery.cn/mjc/jsq/zqhhgg/"];  //混合过关

    }
    return _urlList;
}

@end
