//
//  MainTabBarController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "TagViewController.h"
#import "TotalViewController.h"
#import "ConfigViewController.h"
#import "ScoreViewController.h"


#define kTabImg(P)    [[UIImage imageNamed:P] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

#define kNormalTextAttributes   @{NSForegroundColorAttributeName: HEX_RGB(@"#999999")}
#define kSelectedTextAttributes @{NSForegroundColorAttributeName: HEX_RGB(@"#F2270C")}

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createTabs];
    
    [self setupTabBar];
    
}

- (void)createTabs
{
    NSMutableArray *temp = [NSMutableArray array];
    
    HomeViewController *homeVc = [HomeViewController new];
    homeVc.isMainTabVC = YES;
    homeVc.title = @"首页";
    UITabBarItem *homeItem = homeVc.tabBarItem;
    homeItem.image = kTabImg(@"Tab_Home");
    homeItem.selectedImage = kTabImg(@"Tab_Home_selected");
    if (@available(iOS 26.0, *)) { //ios26必须在这儿设置，否则文字错位 另外普通状态文字颜色无法改变，原因未知
        [homeItem setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
    }
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:homeVc];
    [temp addObject:homeNav];
    
    ScoreViewController *scoreVc = [ScoreViewController new];
    scoreVc.isMainTabVC = YES;
    scoreVc.title = @"比分";
    UITabBarItem *scoreItem = scoreVc.tabBarItem;
    scoreItem.image = kTabImg(@"Tab_Score");
    scoreItem.selectedImage = kTabImg(@"Tab_Score_selected");
    if (@available(iOS 26.0, *)) { //ios26必须在这儿设置，否则文字错位 另外普通状态文字颜色无法改变，原因未知
        [scoreItem setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
    }
    BaseNavigationController *scoreNav = [[BaseNavigationController alloc] initWithRootViewController:scoreVc];
    [temp addObject:scoreNav];
    
    TagViewController *tagVc = [TagViewController new];
    tagVc.isMainTabVC = YES;
    tagVc.title = @"标签";
    UITabBarItem *tagItem = tagVc.tabBarItem;
    tagItem.image = kTabImg(@"Tab_Tag");
    tagItem.selectedImage = kTabImg(@"Tab_Tag_selected");
    if (@available(iOS 26.0, *)) { //ios26必须在这儿设置，否则文字错位 另外普通状态文字颜色无法改变，原因未知
        [tagItem setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
    }
    BaseNavigationController *tagNav = [[BaseNavigationController alloc] initWithRootViewController:tagVc];
    [temp addObject:tagNav];
    
    TotalViewController *totalVc = [TotalViewController new];
    totalVc.isMainTabVC = YES;
    totalVc.title = @"统计";
    UITabBarItem *totalItem = totalVc.tabBarItem;
    totalItem.image = kTabImg(@"Tab_Total");
    totalItem.selectedImage = kTabImg(@"Tab_Total_selected");
    if (@available(iOS 26.0, *)) { //ios26必须在这儿设置，否则文字错位 另外普通状态文字颜色无法改变，原因未知
        [totalItem setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
    }
    BaseNavigationController *totalNav = [[BaseNavigationController alloc] initWithRootViewController:totalVc];
    [temp addObject:totalNav];
    
//    ConfigViewController *configVc = [ConfigViewController new];
//    configVc.isMainTabVC = YES;
//    configVc.title = @"设置";
//    UITabBarItem *configItem = configVc.tabBarItem;
//    configItem.image = kTabImg(@"Tab_Config");
//    configItem.selectedImage = kTabImg(@"Tab_Config_selected");
//    if (@available(iOS 26.0, *)) { //ios26必须在这儿设置，否则文字错位 另外普通状态文字颜色无法改变，原因未知
//        [configItem setTitleTextAttributes:kSelectedTextAttributes forState:UIControlStateSelected];
//    }
//    BaseNavigationController *configNav = [[BaseNavigationController alloc] initWithRootViewController:configVc];
//    [temp addObject:configNav];
    
    self.viewControllers = temp.copy;
    
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

@end
