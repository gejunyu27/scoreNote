//
//  MainTabBarController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "ConfigViewController.h"
#import "TagViewController.h"
#import "TotalViewController.h"

#define kTabImg(P)    [[UIImage imageNamed:P] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

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
    homeVc.tabBarItem.image = kTabImg(@"Tab_Home");
    homeVc.tabBarItem.selectedImage = kTabImg(@"Tab_Home_selected");
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:homeVc];
    [temp addObject:homeNav];
    
    TotalViewController *totalVc = [TotalViewController new];
    totalVc.isMainTabVC = YES;
    totalVc.title = @"统计";
    totalVc.tabBarItem.image = kTabImg(@"Tab_Cart");
    totalVc.tabBarItem.selectedImage = kTabImg(@"Tab_Cart_selected");
    BaseNavigationController *totalNav = [[BaseNavigationController alloc] initWithRootViewController:totalVc];
    [temp addObject:totalNav];

    TagViewController *tagVc = [TagViewController new];
    tagVc.isMainTabVC = YES;
    tagVc.title = @"标签";
    tagVc.tabBarItem.image = kTabImg(@"Tab_Category");
    tagVc.tabBarItem.selectedImage = kTabImg(@"Tab_Category_selected");
    BaseNavigationController *tagNav = [[BaseNavigationController alloc] initWithRootViewController:tagVc];
    [temp addObject:tagNav];

    ConfigViewController *orderVc = [ConfigViewController new];
    orderVc.isMainTabVC = YES;
    orderVc.title = @"设置";
    orderVc.tabBarItem.image = kTabImg(@"Tab_MyOrder");
    orderVc.tabBarItem.selectedImage = kTabImg(@"Tab_MyOrder_selected");
    BaseNavigationController *orderNav = [[BaseNavigationController alloc] initWithRootViewController:orderVc];
    [temp addObject:orderNav];
    
    self.viewControllers = temp.copy;

}

- (void)setupTabBar
{
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
    NSDictionary *normalTextAttributes   = @{NSForegroundColorAttributeName: HEX_RGB(@"#999999"), NSFontAttributeName:SCFONT_SIZED(10)};
    NSDictionary *selectedTextAttributes = @{NSForegroundColorAttributeName: HEX_RGB(@"#F2270C"), NSFontAttributeName:SCFONT_SIZED(10)};

    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    }
    
    
}

@end
