//
//  NSObject+SCHUD.h
//  shopping
//
//  Created by gejunyu on 2020/8/5.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SCHUD)

//转圈
- (void)showLoading;
//隐藏
- (void)stopLoading;

//只显示文字
- (void)showWithStatus:(NSString *)status; //1秒后自动隐藏
- (void)showWithStatus:(NSString *)status delay:(CGFloat)delay;
//- (void)showWithStatusNoHide:(NSString *)status; //不自动隐藏




@end

NS_ASSUME_NONNULL_END
