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
#define activityY NAV_BAR_HEIGHT - 40

@interface SportteryViewController ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIImageView *activityView; //注入js后刷新组件的菊花消失，原因未知，先用这个代替

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
    //起始位置是0，上滑增大，下拉减小
    CGFloat offsetY = scrollView.contentOffset.y;
    //菊花位置
    CGFloat newY = activityY - offsetY;
    self.activityView.top = newY;
    
    //菊花透明度
    if (offsetY >-40) {  //偏移量40之前不显示
        _activityView.alpha = 0;
        
    }else { //超过40后逐渐显示，滑动测试了下，大概170左右开始刷新
//        CGFloat alpha = (-offsetY-40)/(280-40); //170看的不明显，数值设大一点，280
//            if (alpha < 0) alpha = 0;
//            if (alpha > 1) alpha = 1;
//        _activityView.alpha = alpha;
        //代码简化
        if (offsetY < -170) {
            _activityView.alpha = 1;
            
        }else {
            _activityView.alpha = 0.2;
        }
    }

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

- (UIImageView *)activityView
{
    if (!_activityView) {
        CGFloat wh = 30;
        _activityView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-wh)/2, activityY, wh, wh)];
        _activityView.image = [UIImage imageNamed:@"WebRefresh"];
        [self.view addSubview:_activityView];
    }
    return _activityView;
}

@end
