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
#define url_hhgg @"https://m.sporttery.cn/mjc/jsq/zqhhgg/"   //混合过关

@interface SportteryView () <WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *naviBar;  //计算用
@property (nonatomic, strong) UIView *calculateView; //计算
@property (nonatomic, strong) UIButton *outMoneyButton;   //投注金额
@property (nonatomic, strong) UIButton *getMoneyButton;   //理论最高奖金
@property (nonatomic, strong) UIButton *oddsButton;       //计算出赔率
@property (nonatomic, strong) UIButton *planProfitButton; //预期利润
@property (nonatomic, strong) UIButton *planOutButton;    //计算所需投注
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
        [self clearData];
    }

}

- (void)clearData
{
    [_outMoneyButton setTitle:@"2" forState:UIControlStateNormal];
    [_getMoneyButton setTitle:@"" forState:UIControlStateNormal];
    [_oddsButton setTitle:@"" forState:UIControlStateNormal];
    [_planProfitButton setTitle:@"" forState:UIControlStateNormal];
    [_planOutButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.webView.height = self.height;
    
    
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
    if ([urlStr containsString:url_spf] || [urlStr containsString:url_hhgg]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }else { //拦截
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    

}

#pragma mark - webview scrollview代理
#define kWebOffset 63
// 页面加载完成后，直接向下偏移63
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    CGPoint initOffset = CGPointMake(0, kWebOffset);
    webView.scrollView.contentOffset = initOffset;
}

// 核心滚动拦截：禁止向上滑动（offsetY < 20直接锁定在20）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < kWebOffset) {
        scrollView.contentOffset = CGPointMake(0, kWebOffset);
    }
}

#pragma mark -action
- (void)naviBtnClicked:(UIButton *)sender
{
    if (sender == _oddsButton || sender == _planOutButton) {
        return;
    }
    
    [NumberInputView showWithText:sender.currentTitle title:nil clickView:sender type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        [sender setTitle:outputText forState:UIControlStateNormal];
        
        //投注金额和理论最高奖金都有输入，则计算赔率
        CGFloat outMoney = [self.outMoneyButton.currentTitle floatValue];
        CGFloat getMoney = [self.getMoneyButton.currentTitle floatValue];
        CGFloat odds = 0;
        if (outMoney > 0 && getMoney > 0) {
            odds = getMoney/outMoney;
            [self.oddsButton setTitle:[SCUtilities removeFloatSuffix:odds] forState:UIControlStateNormal];
        }else {
            [self.oddsButton setTitle:@"" forState:UIControlStateNormal];
        }
        
        //赔率和预期利润都有输入，则计算所需投注
        CGFloat planProfit = [self.planProfitButton.currentTitle floatValue];
        CGFloat planOut = 0;
        if (odds > 1 && planProfit > 0) {
            planOut = planProfit/(odds-1);
            [self.planOutButton setTitle:[SCUtilities removeFloatSuffix:planOut] forState:UIControlStateNormal];
        }else {
            [self.planOutButton setTitle:@"" forState:UIControlStateNormal];
        }
        
    }];
    
}

- (void)closeClicked
{
    if ([self.delegate respondsToSelector:@selector(sportteryCloseClicked)]) {
        [self.delegate sportteryCloseClicked];
    }
}

- (void)refershClicked
{
    [self.webView reload];
}

- (void)calculateClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        self.calculateView.left = 0;
    } completion:nil];
}

- (void)switchClicked
{
    NSString *currentUrl = self.webView.URL.absoluteString;
    
    if ([currentUrl isEqualToString:url_spf]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url_hhgg]]];
        
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url_spf]]];
    }
}

- (void)calculteOutClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        self.calculateView.left = self.naviBar.width;
    } completion:^(BOOL finished) {
        [self clearData];
    }];
}

#pragma mark -UI
- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore]; //使用默认的持久化数据储存（自动存Cooki、登录状态等）
  
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) configuration:config];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _webView.scrollView.bounces = NO; //取消回弹
        _webView.pageZoom = 0.9; //缩放
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [self addSubview:_webView];
        [self insertSubview:self.naviBar aboveSubview:_webView];
        
        NSURL *url = [NSURL URLWithString:url_spf]; //胜平负
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
        //存储加载时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KEY_WEB_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return _webView;
}

- (UIView *)naviBar
{
    if (!_naviBar) {
        CGFloat w = self.width;
        CGFloat h = 45;
        
        _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _naviBar.backgroundColor = HEX_RGB(@"#E55851");
    
        
        [self addSubview:_naviBar];
        
        CGFloat btnWH = 22;
        
        //关闭
        UIButton *closebtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (h-btnWH)/2, btnWH, btnWH)];
        [closebtn setImage:[UIImage imageNamed:@"WebClose"] forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:closebtn];
        
        //刷新
        UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(closebtn.right+25, closebtn.top, btnWH, btnWH)];
        [refreshBtn setImage:[UIImage imageNamed:@"WebRefresh"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refershClicked) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:refreshBtn];
        
        //标题
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = SCFONT_SIZED(22);
        titleLabel.text = @"中国竞彩网";
        [titleLabel sizeToFit];
        titleLabel.centerX = w/2;
        titleLabel.centerY = h/2;
        [_naviBar addSubview:titleLabel];
        
        //计算器
        UIButton *calculateBtn = [[UIButton alloc] initWithFrame:CGRectMake(w-15-btnWH, closebtn.top, btnWH, btnWH)];
        [calculateBtn setImage:[UIImage imageNamed:@"WebCalculate"] forState:UIControlStateNormal];
        [calculateBtn addTarget:self action:@selector(calculateClicked) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:calculateBtn];
        
        //切换
        UIButton *switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(calculateBtn.left-25-btnWH, closebtn.top, btnWH, btnWH)];
        [switchBtn setImage:[UIImage imageNamed:@"WebSwitch"] forState:UIControlStateNormal];
        [switchBtn addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:switchBtn];
        
    }
    return _naviBar;
}

- (UIView *)calculateView
{
    if (!_calculateView) {
        CGFloat w = self.naviBar.width;
        CGFloat h = self.naviBar.height;
        _calculateView = [[UIView alloc] initWithFrame:CGRectMake(w, 0, w, h)];
        _calculateView.backgroundColor = self.naviBar.backgroundColor;
        [_naviBar addSubview:_calculateView];
        
        //收回按钮
        CGFloat outWH = 22;
        UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(w-outWH-10, (h-outWH)/2, outWH, outWH)];
        [outBtn setImage:[UIImage imageNamed:@"WebOut"] forState:UIControlStateNormal];
        [outBtn addTarget:self action:@selector(calculteOutClicked) forControlEvents:UIControlEventTouchUpInside];
        [_calculateView addSubview:outBtn];
        
        CGFloat labelW = (outBtn.left-5)/5;
        
        for (int i=0; i<5; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelW*i, 3, labelW, 11)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = SCFONT_SIZED(label.height-1);
            [_calculateView addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, label.bottom+3, 50, 22)];
            btn.titleLabel.font = SCFONT_SIZED(15);
            btn.centerX = label.centerX;
            btn.layer.cornerRadius = 5;
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_calculateView addSubview:btn];
            
            if (i!=2 && i!=4) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
            }
            
            if (i==0) {
                label.text = @"投注金额";
                [btn setTitle:@"2" forState:UIControlStateNormal];
                _outMoneyButton = btn;
                
            }else if (i==1) {
                label.text = @"理论最高奖金";
                _getMoneyButton = btn;
                
            }else if (i==2) {
                label.text = @"计算出赔率";
                btn.userInteractionEnabled = NO;
                _oddsButton = btn;
                
            }else if (i==3) {
                label.text = @"预期利润";
                _planProfitButton = btn;
                
            }else if (i==4) {
                label.text = @"计算所需投注";
                btn.userInteractionEnabled = NO;
                _planOutButton = btn;
            }
        }
    }
    return _calculateView;
}

@end
