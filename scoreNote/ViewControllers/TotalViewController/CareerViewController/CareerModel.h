//
//  CareerModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import <Foundation/Foundation.h>
@class RecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface CareerModel : NSObject
@property (nonatomic, strong, readonly) RecordModel *record;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *tip;

@property (nonatomic, assign) BOOL isCanFollowing; //是否包含未结束的数据  暂时无用

- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content tip:(nullable NSString *)tip record:(nullable RecordModel *)record;
- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content record:(nullable RecordModel *)record;
- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content tip:(nullable NSString *)tip;
- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
