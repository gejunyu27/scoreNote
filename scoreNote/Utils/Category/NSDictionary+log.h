//
//  NSDictionary+log.h
//  SCShopSDK_Example
//
//  Created by gejunyu on 2021/8/2.
//  Copyright © 2021 gejunyu5. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;

@end

@interface NSArray (log)
- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level;

@end

NS_ASSUME_NONNULL_END
