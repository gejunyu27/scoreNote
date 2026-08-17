//
//  SportteryViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/2.
//

#import "SportteryViewController.h"

#import <WebKit/WebKit.h>
#import "NetworkReachability.h"
#import "CalculatorView.h"
#import "WebNaviBar.h"

#define naviY (NAV_BAR_HEIGHT+8)   //原生导航栏初始高度 适配机型

@interface SportteryViewController ()<WKNavigationDelegate, UIScrollViewDelegate, WebNaviBarDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WebNaviBar *naviBar;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *indicator; //注入js后刷新组件的菊花消失，可能是因为y过高在屏幕外面，解决之前先用这个代替
@property (nonatomic, strong) CalculatorView *calculatorView; //计算器视图
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
    CGFloat topPaddingValue = IS_BANGS_SCREEN ? 20.f : 12.f;
    
    NSString *js = [NSString stringWithFormat:
    @"setTimeout(function(){"
    // 网页整体顶部留出空白，数值自行调整  = 空白高度px
    @"document.documentElement.style.paddingTop = '%.0fpx';"
    @"document.body.style.paddingTop = '%.0fpx';"
    // 删除全部 m-header 标题栏
    @"document.querySelectorAll('.m-header').forEach(function(item){item.remove();});"
    // 隐藏 calculator_menu 保留高度 胜平负，混合，比分等选项
    @"var menuDom = document.getElementById('calculator_menu');"
    @"if(menuDom){"
    @"    menuDom.style.visibility = 'hidden';"
    @"}"
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
    
    //调整菊花
    [self configIndicatorWithOffsetY:offsetY];
    
    //调整导航栏
    [self confitNaviBarWithOffsetY:offsetY];

}

- (void)configIndicatorWithOffsetY:(CGFloat)offsetY
{
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

- (void)confitNaviBarWithOffsetY:(CGFloat)offsetY
{
    //导航栏位置
    CGFloat newY = naviY - offsetY;
    self.naviBar.top = newY;
    
    //导航栏透明度
    CGFloat fadeDistance = 30; //透明度变化完的最大滑动距离
    CGFloat alpha = 1.0 - (offsetY / fadeDistance);
    if (alpha < 0.2) alpha = 0.2;
    if (alpha > 1) alpha = 1;
    _naviBar.alpha = alpha;
}

#pragma mark -WebNaviBarDelegate
- (void)webNaviBarSelectIndex:(NSInteger)index
{
    if (index >= self.urlList.count) {
        return;
    }
    
    NSString *url = self.urlList[index];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
        [self.calculatorView clear];
    }
}

//滑动手势
- (void)panScrollHandle:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat offsetX = [pan translationInView:self.webView].x;
        //横向滑动阈值 40px，超过判定为切换Tab
        CGFloat maxX = 40;
        if (offsetX > maxX) { //手指右滑，切换左边页面 导航栏有纠错机制
            self.naviBar.selectedIndex--;
            
        } else if (offsetX < -maxX) { //手指左滑，切换右边页面
            self.naviBar.selectedIndex++;
        }
    }
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

- (CalculatorView *)calculatorView
{
    if (!_calculatorView) {
        CGFloat x = 20;
        CGFloat h = 65;
        _calculatorView = [[CalculatorView alloc] initWithFrame:CGRectMake(x, SCREEN_HEIGHT-TAB_BAR_HEIGHT-10-h, SCREEN_WIDTH-x*2, h)];
        _calculatorView.hidden = YES;
        [self.view addSubview:_calculatorView];
        
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

- (WebNaviBar *)naviBar
{
    if (!_naviBar) {
        _naviBar = [[WebNaviBar alloc] initWithFrame:CGRectMake(0, naviY, SCREEN_WIDTH, 40)];
        [_naviBar createButtonsWithTitleList:@[@"胜平负", @"比分", @"总进球", @"半全场", @"混合过关"] selectedColor:HEX_RGB(@"#EC6660") font:SCFONT_SIZED(16)];
        _naviBar.delegate = self;
        [self.view addSubview:_naviBar];
    }
    return _naviBar;
}
@end
