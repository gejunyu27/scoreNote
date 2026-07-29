//
//  SportteryView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/7/29.
//

#import "SportteryView.h"
#import <WebKit/WebKit.h>
#import "NetworkReachability.h"

//竞彩网相关参数
#define KEY_WEB_DATE @"KEY_WEB_DATE"
#define url_spf  @"https://m.sporttery.cn/mjc/jsq/zqspf/"    //胜平负
#define url_bf   @"https://m.sporttery.cn/mjc/jsq/zqbf/"     //比分
#define url_zjq  @"https://m.sporttery.cn/mjc/jsq/zqzjq/"    //总进球
#define url_bqc  @"https://m.sporttery.cn/mjc/jsq/zqbqc/"    //半全场
#define url_hhgg @"https://m.sporttery.cn/mjc/jsq/zqhhgg/"   //混合过关

@interface SportteryView () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation SportteryView

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    
    if (isShow) { //展示
        self.hidden = NO;
        //判断有没有网
        BOOL isNetworkOK = [NetworkReachability isReachable];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
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
        
    }else {
        self.hidden = YES;
        [NetworkReachability stopMontitorNetwork]; //停止监测
    }

}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.webView.frame = self.bounds;
}

#pragma mark - WKNavigationDelegate 核心跳转拦截（监测点击按钮/链接跳转）
/**
 页面即将发起跳转（所有a标签、js跳转、按钮window.location都会进这里）
 navigationAction.request.URL = 即将要打开的页面地址
 navigationAction.navigationType 判断跳转类型：链接点击、表单提交、返回前进、页面重定向等
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    /**加入以下拦截代码原因，因为要把原网页中后退按钮覆盖掉，而跳转的几个页面也不需要用到。所以屏蔽跳转。**/
    // 1. 获取即将跳转的URL
    NSURL *targetURL = navigationAction.request.URL;
    NSString *urlStr = targetURL.absoluteString;

    //只允许跳转的几个页面
    if ([urlStr containsString:url_spf] || [urlStr containsString:url_bf] || [urlStr containsString:url_zjq] || [urlStr containsString:url_bqc] || [urlStr containsString:url_hhgg]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }else { //拦截
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    

}


#pragma mark -UI
- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore]; //使用默认的持久化数据储存（自动存Cooki、登录状态等）
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) configuration:config];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _webView.scrollView.bounces = NO; //取消回弹
        _webView.pageZoom = 0.9; //缩放
        _webView.navigationDelegate = self;
        [self addSubview:_webView];
        
        NSURL *url = [NSURL URLWithString:url_spf]; //胜平负
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
        //存储加载时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KEY_WEB_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return _webView;
}

@end
