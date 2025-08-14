//
//  BaseViewController.h
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isMainTabVC;        //是否是首页tab

- (void)addKeyboardNotification;//添加键盘监控

@end

NS_ASSUME_NONNULL_END
