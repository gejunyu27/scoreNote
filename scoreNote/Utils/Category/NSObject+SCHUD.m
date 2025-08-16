//
//  NSObject+SCHUD.m
//  shopping
//
//  Created by gejunyu on 2020/8/5.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "NSObject+SCHUD.h"

static CGFloat kDelay = 1;

@interface SCHUD : UILabel
AS_SINGLETON(SCHUD)
@property (nonatomic, strong) UIActivityIndicatorView *actView;
- (void)showWithStatus:(NSString *)status;
- (void)hide;
- (void)showLoading;

@end

@implementation SCHUD
DEF_SINGLETON(SCHUD)

#pragma mark -ui
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setActViewFrame];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        
        _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _actView.color = [UIColor whiteColor];
        _actView.frame = self.bounds;
        [self addSubview:_actView];
    }
    return self;
}

- (void)setTextFrame
{
    [self setupWidth:210 height:55];
}

- (void)setActViewFrame
{
    [self setupWidth:100 height:100];
}

- (void)setupWidth:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake((SCREEN_WIDTH-width)/2, (SCREEN_HEIGHT-height)/2, width, height);
}

- (void)show
{
    UITabBarController *tabVc = [SCUtilities currentTabBarController];
    
    tabVc.view.userInteractionEnabled = NO;

    [tabVc.view addSubview:self];
}

- (void)hide
{
    [self.actView stopAnimating];
    [self removeFromSuperview];
    
    UITabBarController *tabVc = [SCUtilities currentTabBarController];
    
    tabVc.view.userInteractionEnabled = YES;
}

- (void)showWithStatus:(NSString *)status
{
    self.actView.hidden = YES;
    
    self.text = status;
    
    //根据字数重新设置长宽，代码尽量精简，不用约束
    [self setTextFrame];
    if (status.length > 10) {
        NSInteger more = status.length - 10;
        [self setupWidth:(self.width + more*15) height:self.height];
    }
    
    [self show];
    
}

- (void)showLoading
{
    self.text = nil;
    [self setActViewFrame];
    
    self.actView.hidden = NO;
    
    [self.actView startAnimating];
    
    [self show];
}

@end

@implementation NSObject (SCHUD)

//转圈
- (void)showLoading
{
    SCHUD *hudView = [SCHUD sharedInstance];
    
    [hudView showLoading];
}

//只显示文字
- (void)showWithStatus:(NSString *)status //1.5秒后自动隐藏
{
    SCHUD *hudView = [SCHUD sharedInstance];
    
    [hudView showWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hudView hide];
    });
}

- (void)showWithStatusNoHide:(NSString *)status //不自动隐藏
{
    SCHUD *hudView = [SCHUD sharedInstance];
    
    [hudView showWithStatus:status];
}

//隐藏
- (void)stopLoading
{
    SCHUD *hudView = [SCHUD sharedInstance];
    
    [hudView hide];
}

@end

