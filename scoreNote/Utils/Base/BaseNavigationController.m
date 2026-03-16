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


    
    if (@available(iOS 26.0, *)) { //ios26 采用毛玻璃样式
        
//        UINavigationBarAppearance *standardAppearance   = [UINavigationBarAppearance new];
//        standardAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLiquidGlass]
//
//        UINavigationBarAppearance *scrollEdgeAppearance = [UINavigationBarAppearance new];
        
        
    }else {
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *ba = [UINavigationBarAppearance new];
            ba.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            ba.backgroundColor = [UIColor whiteColor];
            ba.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
            self.navigationBar.scrollEdgeAppearance = ba;
            self.navigationBar.standardAppearance = ba;
        }
        
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
