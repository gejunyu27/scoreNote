//
//  BaseViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置右滑返回手势的代理为自身 (这个手势模拟器可能无效，真机有效)
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

}

#pragma mark -键盘
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNoti:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNoti:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardNoti:(NSNotification *)noti
{
    //获取键盘的高度
//    NSDictionary *userInfo = [noti userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    _keyboardHeight = keyboardRect.size.height;
//    
//    NSLog(@"%f",_keyboardHeight);
    
    BOOL isShow = [noti.name isEqualToString:UIKeyboardWillShowNotification];
    
    CGFloat top = self.navigationController ? NAV_BAR_HEIGHT : 0;
    
    self.view.top = isShow ? top-200 : top;
    
    
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.navigationController.viewControllers.count < 2 ||
            self.navigationController.visibleViewController == [self.navigationController.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
