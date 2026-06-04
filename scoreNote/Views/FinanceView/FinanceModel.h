//
//  FinanceModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinanceModel : NSObject

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;

@end

NS_ASSUME_NONNULL_END
