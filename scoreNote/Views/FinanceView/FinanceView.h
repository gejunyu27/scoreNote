//
//  FinanceView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import "FinanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinanceView : UIView
@property (nonatomic, strong) NSArray <FinanceModel *> *models;

//添加右侧按钮 写法1
- (void)addFunctionButtonWithImage:(id)image target:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
//添加右侧按钮 写法2
- (void)addFunctionButtonWithImage:(id)image eventHandler:(void (^)(id sender))handler;

@end

NS_ASSUME_NONNULL_END
