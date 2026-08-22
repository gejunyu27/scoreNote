//
//  MainTabBarController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "ScoreViewController.h"
#import "SportteryViewController.h"
#import "StatsViewController.h"

#define kNormalTextAttributes   @{NSForegroundColorAttributeName: HEX_RGB(@"#999999")}
#define kSelectedTextAttributes @{NSForegroundColorAttributeName: HEX_RGB(@"#F2270C")}

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createTabs];
    
    [self setupTabBar];
    
//    [self setupNaviBar]; //用毛玻璃效果
}

- (void)createTabs
{
    NSMutableArray *temp = [NSMutableArray array];
    
    [temp addObject:[self getNavVcFrom:[HomeViewController new] title:@"首页" tabImage:@"Tab_Home" tabSelectedImage:@"Tab_Home_selected"]];
    
    [temp addObject:[self getNavVcFrom:[SportteryViewController new] title:@"竞彩" tabImage:@"Tab_Sporttery" tabSelectedImage:@"Tab_Sporttery_selected"]];
    
    [temp addObject:[self getNavVcFrom:[ScoreViewController new] title:@"比分" tabImage:@"Tab_Score" tabSelectedImage:@"Tab_Score_selected"]];

    [temp addObject:[self getNavVcFrom:[StatsViewController new] title:@"统计" tabImage:@"Tab_Stats" tabSelectedImage:@"Tab_Stats_selected"]];
    
    self.viewControllers = temp.copy;
    
}

- (BaseNavigationController *)getNavVcFrom:(BaseViewController *)vc title:(NSString *)title tabImage:(NSString *)tabImage tabSelectedImage:(NSString *)tabSelectedImage
{
    BaseViewController *tabVc = vc;
    vc.isMainTabVC = YES;
    vc.title = title;
    UITabBarItem *tabItem = tabVc.tabBarItem;
    tabItem.image = [[UIImage imageNamed:tabImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem.selectedImage = [[UIImage imageNamed:tabSelectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if (@available(iOS 26.0, *)) { //ios26必须在这儿设置，否则文字错位 另外普通状态文字颜色无法改变，原因未知
        [tabItem setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
    }
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:tabVc];
    return nav;
}

- (void)setupTabBar
{
    if (@available(iOS 26.0, *)) { //ios26新增毛玻璃效果，不再使用传统效果
        return;
    }
    
    //传统效果
    //    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    //    self.tabBar.shadowImage     = [UIImage new];
    self.tabBar.barStyle     = UIBarStyleBlack;
    self.tabBar.translucent  = NO;
    self.tabBar.barTintColor = [UIColor whiteColor];
    //阴影
    self.tabBar.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.tabBar.layer.shadowOffset  = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.3;
    
    //字体颜色
    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:kNormalTextAttributes forState:UIControlStateNormal];
        [item setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
    }
}

- (void)setupNaviBar
{
    UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
    // ✅关键：启用不透明背景，关闭系统毛玻璃材质
    [navBarAppearance configureWithOpaqueBackground];
    // 设置默认底色（你想要的默认白色）
    navBarAppearance.backgroundColor = [UIColor whiteColor];
    
    // 标题文字颜色
    navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    // 底部分割线（不需要就设clear）
    navBarAppearance.shadowColor = [UIColor clearColor];
    
    // 重中之重：standardAppearance + scrollEdgeAppearance 必须同时赋值
    // scrollEdgeAppearance 控制列表滚动到顶部时不会自动变透明毛玻璃
    [UINavigationBar appearance].standardAppearance = navBarAppearance;
    [UINavigationBar appearance].scrollEdgeAppearance = navBarAppearance;
    
    // 全局统一按钮颜色（返回箭头、导航栏按钮）
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
}

@end
