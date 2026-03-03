//
//  BaseNavigationController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *ba = [UINavigationBarAppearance new];
        ba.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        ba.backgroundColor = [UIColor whiteColor];
        ba.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        self.navigationBar.scrollEdgeAppearance = ba;
        self.navigationBar.standardAppearance = ba;
    }
    
    if (@available(iOS 26.0, *)) { //ios26 导航栏分割线消失，与毛玻璃样式有关。如果需要，在这儿自建分割线，但跳转页面会消失，不建议用
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54-0.5, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        [self.navigationBar addSubview:line];
        
    }else {
            self.view.backgroundColor = [UIColor whiteColor];
            self.navigationBar.translucent = NO;
        //    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
            self.navigationBar.barTintColor = [UIColor whiteColor];
            self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:BaseViewController.class]) {
        BaseViewController *pushedVc = (BaseViewController *)viewController;
        
        pushedVc.hidesBottomBarWhenPushed = !pushedVc.isMainTabVC;
        
    }else {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
}

@end
