//
//  ScoreViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/2.
//

#import "ScoreViewController.h"
#import <WebKit/WebKit.h>
#import "NetworkReachability.h"

//#define url_score @"https://m.okooo.com/live/"   //澳客体育
#define url_score @"https://zucaijia.cn/zcj/H5App/index"    //加加体育
#define naviY (NAV_BAR_HEIGHT+15)

@interface ScoreViewController ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIButton *playingButton; //进行中
@property (nonatomic, strong) UIButton *overButton;   //结束
@property (nonatomic, strong) UIView *sepLine; //滑块
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_score]];
        
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
    // 1. 获取即将跳转的URL
    NSURL *targetURL = navigationAction.request.URL;
    NSString *urlStr = targetURL.absoluteString;
    
    //只允许跳转的几个页面
    if ([urlStr containsString:url_score]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }else { //拦截
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    
    
}

#pragma mark - webview scrollview代理
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
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
    NSString *jsScript =
    @"// 1.topdiv是顶部绿色标题栏，不能删除，会导致布局错乱，压缩隐藏，保留DOM防止布局错乱\n"
    @"var topDiv = document.querySelector('.topdiv');\n"
    @"if(topDiv){\n"
    @"    topDiv.style.height = '0px';\n"
    @"    topDiv.style.overflow = 'hidden';\n"
    @"    topDiv.style.padding = '0';\n"
    @"    topDiv.style.margin = '0';\n"
    @"}\n"
    //顶部导航栏不置顶，可以滑动
    @"var tabUl = document.querySelector('ul.ui-tab-nav');\n"
    @"if(tabUl){\n"
    @"    tabUl.style.height = '0px';\n"
    @"    tabUl.style.overflow = 'hidden';\n"
    @"    tabUl.style.padding = '0';\n"
    @"    tabUl.style.margin = '0';\n"
    @"};\n"
    // 3.删除 buttondiv广告容器 底部的黑色tabbar
    @"document.querySelectorAll('.buttondiv').forEach(function(item){\n"
    @"    if(item) item.remove();\n"
    @"});\n"
    // 4.删除两个点击事件广告按钮  下载APP按钮和客服按钮
    @"document.querySelectorAll('*').forEach(function(el){\n"
    @"    var clickFn = el.getAttribute('onclick');\n"
    @"    if(clickFn){\n"
    @"        if(clickFn.indexOf('showdown()') > -1 || clickFn.indexOf('goq()') > -1){\n"
    @"            el.remove();\n"
    @"        }\n"
    @"    }\n"
    @"});\n"
    // ========== 重点：消除顶部大块空白 ==========
    @"document.body.style.paddingTop = '0px';\n"
    @"document.documentElement.style.paddingTop = '0px';\n"
    // 给页面所有主要容器取消上边距，内容顶到最顶部
    @"document.querySelectorAll('div,section,.content,.main').forEach(function(box){\n"
    @"    box.style.marginTop = '0px';\n"
    @"    box.style.paddingTop = '0px';\n"
    @"});\n"
    // 清理底部留白
    @"document.body.style.paddingBottom = '0px';";
    [self.webView evaluateJavaScript:jsScript completionHandler:nil];
}

- (void)endRefresh
{
    // 结束下拉刷新动画
    if (self.refreshControl.refreshing) {
        [self.refreshControl endRefreshing];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //初始会有116的偏移  重新设置后起始位置是0，上滑增大，下拉减小
    CGFloat offsetY = scrollView.contentOffset.y + 116;
    //导航栏位置
    CGFloat newY = naviY - offsetY;
    self.naviBar.top = newY;
    
    
    //导航栏透明度
    //    CGFloat fadeDistance = 50; //透明度变化完的最大滑动距离
    //    CGFloat alpha = 1.0 - (offsetY / fadeDistance);
    //    if (alpha < 0) alpha = 0;
    //    if (alpha > 1) alpha = 1;
    //    _naviBar.alpha = alpha;
    //透明度简化 滑了就透明
    self.naviBar.alpha = offsetY > 0 ? 0.2 : 1;
}

#pragma mark -action
- (void)naviClicked:(UIButton *)sender
{
    [self swithNavi:(sender == _playingButton)];
}

- (void)panScrollHandle:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat offsetX = [pan translationInView:self.webView].x;
        //横向滑动阈值 40px，超过判定为切换Tab
        CGFloat maxX = 40;
        if (offsetX > maxX) {
            //右滑
            [self swithNavi:YES];
        } else if (offsetX < -maxX) {
            //左滑
            [self swithNavi:NO];
        }
    }
}

- (void)swithNavi:(BOOL)isPlaying
{
    if (isPlaying) {
        _playingButton.selected = YES;
        _overButton.selected = NO;
        _sepLine.left = _playingButton.left;
    }else {
        _playingButton.selected = NO;
        _overButton.selected = YES;
        _sepLine.left = _overButton.left;
    }
    
    
    NSInteger index = isPlaying ? 0 : 1;
    
    NSString *js = [NSString stringWithFormat:
                    @"var x = %ld;\n"
                    @"for (var j = 0; j < 5; j++) {\n"
                    @"    if (x == j) {\n"
                    @"        $('#li' + j).addClass('current');\n"
                    @"        $('#lis' + j).show();\n"
                    @"        window.scrollTo(0,0);\n"
                    @"    } else {\n"
                    @"        $('#li' + j).removeClass('current');\n"
                    @"        $('#lis' + j).hide();\n"
                    @"    }\n"
                    @"}",(long)index];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

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

- (UIView *)naviBar
{
    if (!_naviBar) {
        _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, naviY, SCREEN_WIDTH, 38)];
        _naviBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_naviBar];
        
        CGFloat lineH = 2;
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, _naviBar.height-lineH, _naviBar.width/2, lineH)];
        _sepLine.backgroundColor = HEX_RGB(@"#87BF3B");
        [_naviBar addSubview:_sepLine];
        
        CGFloat w = _naviBar.width/2;
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w*i, 0, w, _sepLine.top)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:_sepLine.backgroundColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(naviClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                [btn setTitle:@"即时" forState:UIControlStateNormal];
                btn.selected = YES;
                _playingButton = btn;
            }else {
                [btn setTitle:@"完场" forState:UIControlStateNormal];
                _overButton = btn;
            }
            [_naviBar addSubview:btn];
        }
        
    }
    return _naviBar;
}

@end
