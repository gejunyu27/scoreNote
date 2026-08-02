//
//  AppDelegate.m
//  DEMO
//
//  Created by Zhuanz密码0000 on 2026/3/29.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configKeyboard];
    return YES;
}

- (void)configKeyboard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 总开关：开启键盘避让
    manager.shouldResignOnTouchOutside = YES; // 点击空白收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 工具条颜色跟随输入框
    manager.enableAutoToolbar = NO; // 输入框上方显示工具栏（上一项、下一项、完成） 大部分建议关闭
//    manager.keyboardDistanceFromTextField = 12;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
