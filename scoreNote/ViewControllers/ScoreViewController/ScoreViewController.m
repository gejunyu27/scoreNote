//
//  ScoreViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/2.
//

#import "ScoreViewController.h"
#import <WebKit/WebKit.h>
#import "NetworkReachability.h"

#define url_score @"https://m.okooo.com/live/"

@interface ScoreViewController ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
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
//#define kWebOffset 63
//// 页面加载完成后，直接向下偏移63
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    CGPoint initOffset = CGPointMake(0, kWebOffset);
//    webView.scrollView.contentOffset = initOffset;
//}
//
//// 核心滚动拦截：禁止向上滑动（offsetY < 20直接锁定在20）
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y < kWebOffset) {
//        scrollView.contentOffset = CGPointMake(0, kWebOffset);
//    }
//}

#pragma mark -UI
- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore]; //使用默认的持久化数据储存（自动存Cooki、登录状态等）
        
        WKUserContentController *userCtrl = [[WKUserContentController alloc] init];
        // DOM就绪直接删除底部导航
        NSString *injectJS =
        @"document.addEventListener('DOMContentLoaded',function(){\
            document.querySelector('.live-list-tip')?.remove();\
            document.querySelector('.live-new-header')?.remove();\
            document.querySelector('.footer-nav')?.remove();\
            document.body.style.paddingBottom = '0px';\
            document.documentElement.style.paddingBottom = '0px';\
        });";

        WKUserScript *script = [[WKUserScript alloc] initWithSource:injectJS
                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                     forMainFrameOnly:NO];
        [userCtrl addUserScript:script];
        config.userContentController = userCtrl;

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _webView.scrollView.bounces = NO; //取消回弹
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [self.view addSubview:_webView];

    }
    return _webView;
}


@end
