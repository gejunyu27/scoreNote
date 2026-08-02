//
//  SportteryViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/2.
//

#import "SportteryViewController.h"

#import <WebKit/WebKit.h>
#import "NetworkReachability.h"

#define url_spf  @"https://m.sporttery.cn/mjc/jsq/zqspf/"    //胜平负
#define url_hhgg @"https://m.sporttery.cn/mjc/jsq/zqhhgg/"   //混合过关

//#define naviY (NAV_BAR_HEIGHT+15)

@interface SportteryViewController ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation SportteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_spf]];
        
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
    
    decisionHandler(WKNavigationActionPolicyAllow);
    return;
    /**加入拦截。**/
    // 1. 获取即将跳转的url
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    //只允许跳转的几个页面
    if ([urlStr containsString:url_spf] || [urlStr containsString:url_hhgg]) {
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
//    NSString *js = @"document.body.style.marginTop = '44px';document.documentElement.style.marginTop='44px';";
//    [_webView evaluateJavaScript:js completionHandler:nil];
    NSString *js =
    @"setTimeout(function(){"
    // 删除全部 m-header
    @"document.querySelectorAll('.m-header').forEach(function(item){item.remove();});"
    // 隐藏 calculator_menu 保留高度
    @"var menuDom = document.getElementById('calculator_menu');"
    @"if(menuDom){"
    @"    menuDom.style.visibility = 'hidden';"
    @"}"
    //直接移除 id="sel_pan"
    @"var selPan = document.getElementById('sel_pan');"
    @"if(selPan) selPan.remove();"
    @"},000);"; //这个0是延迟执行时间，避免失效，但目前测试不需要延迟也可以
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
    CGFloat offsetY = scrollView.contentOffset.y;
    
    NSLog(@"%f", offsetY);
}

#pragma mark -action
- (void)webRefreshAction
{
    // 网页重载
    [self.webView reload];
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
    
        //下拉刷新
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [UIColor grayColor];
        [_refreshControl addTarget:self action:@selector(webRefreshAction) forControlEvents:UIControlEventValueChanged];
        // 挂载到webview滚动视图
        self.webView.scrollView.refreshControl = self.refreshControl;
        
    }
    return _webView;
}

@end
