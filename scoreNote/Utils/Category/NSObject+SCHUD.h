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

//只显示文字
- (void)showWithStatus:(NSString *)status; //1.5秒后自动隐藏
- (void)showWithStatusNoHide:(NSString *)status; //不自动隐藏

//隐藏
- (void)stopLoading;


@end

NS_ASSUME_NONNULL_END
